module ExternalChannel
  class ShopeeAdapter < BaseAdapter
    attr_reader :base_url

    # === 사용 가능한 PRODUCT query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    # === from 과 to 사이 최대 기간은 15일임. 받으려면 15일 간격으로 잘라서 받아야 함.
    #{
    #  update_time_from
    #  update_time_to
    #  pagination_offset : not null
    #  pagination_entries_per_page : not null, max 100
    #}


    # === 사용 가능한 Order query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    # https://open.tiki.vn/#order-api-v2
    #{
    #}

    def initialize
      @base_url = 'https://partner.shopeemobile.com/api/v1'
      @shop_id = Rails.application.credentials.dig(:shopee, :api, :shopid)
      @partner_id = Rails.application.credentials.dig(:shopee, :api, :partner_id)
      @key = Rails.application.credentials.dig(:shopee, :api, :key)
    end

    public
    # == 적절하게 정제된 데이터를 리턴합니다.
    def products(query_hash = {})
      ap refine_products(call_products(query_hash))
    end

    def orders(query_hash = {})
      refine_orders(call_orders(query_hash))
    end

    protected

    def login; end

    # == 외부 채널의 API 를 사용하여 각 레코드를 가져옵니다.
    def call_products(query_hash = {})
      query_hash[:pagination_offset] ||= 0
      # === TODO: 테스트를 위해서 개수를 10개로 제한.
      query_hash[:pagination_entries_per_page] ||= 10

      products_url = "#{base_url}/items/get"
      products_body = set_shopee_body(query_hash)

      product_ids = []
      call_list(products_url, products_body) do |response|
        product_ids << response['items'].pluck('item_id')
      end
      call_product_by_ids(product_ids.flatten)
    end

    def call_orders(query_hash)
    end
    # == call_XXX 로 가져온 레코드를 정제합니다.
    def refine_products(products)
      products.map do |product|
        {
            id: product['item_id'],
            title: product['name'],
            channel_name: 'shopee',
            brand_name: refine_brand_name(product['attributes']),
            variants: refine_variants(product)
        }
      end
    end

    # === TODO: No Brand인 경우 베트남 측에서 관리하지 않은 브랜드로 보인다. 이것을 어떻게 처리할지 논의가 필요하다.
    # === 우려되는 사항은 다음과 같다.
    # === 1. 가격등 브랜드와 관련 없는 정보가 바뀔 경우 브랜드를 다시 No Brand로 설정 할 수 있다.
    def refine_brand_name(attr)
      brand_attr = attr.find{|attr| attr['attribute_name'] == "Thương hiệu"}
      brand_attr['attribute_value']
    end

    def refine_variants(product)
      variants = product['variations']

      # === variants가 없으면 product를 참조 해야 한다.
      return [{
          id: product['item_id'],
          price: product['price'],
          name: 'default'
      }] if variants.empty?

      variants.map do |variant|
        {id: variant['variation_id'], price: variant['price'], name: variant['name']}
      end
    end

    def refine_orders(records)
    end

    private

    attr_reader :partner_id, :key, :shop_id

    def call_product_by_ids(ids)
      url = "#{base_url}/item/get"
      call_each_by_ids(ids, url, 'item') do |id|
        {item_id: id}
      end
    end

    # body를 의미하는 block을 받아, 모든 id에 대해 post요청을 보내고 타겟에 대한 묶음을 전달하는 함수.
    def call_each_by_ids(ids, url, target)
      ids.map do |id|
        body = {}
        if block_given?
          body = yield id
        end
        body = set_shopee_body(body)
        header = get_shopee_header(url, body)
        response = request_post(url, body, header)
        response[target]
      end
    end

    # === 쇼피의 데이터 중 more 이라는 데이터가 있는 것들은 pagination을 따로 하지 않고, more로만 붙여 준다.
    # === order와 product의 list요청에는 모두 more이라는 데이터가 확인되어, 앞으로 user등의 데이터가 추가되어도 사용될 것이라 기대하고 설정함.
    # === 암것도 모드고 while 문 내에서 more이 false가 될 때까지 부름.
    def call_list(url, body)
      more = true
      body[:pagination_offset] ||= 0
      # ===  Todo: 테스트를 위해 pagination_offset을 1개로 고정
      while more && body[:pagination_offset] < 1 do
        header = get_shopee_header(url, body)
        response = request_post(url, body, header)
        more = response['more']
        body[:pagination_offset] += 1
        if block_given?
          yield response
        else
          throw NotImplementedError('call all need block to run')
        end
      end
    end

    def get_shopee_header(url, body)
      {
          'Authorization': make_shopee_signature(url, body),
          'Content-Type': 'application/json'
      }
    end

    def set_shopee_body(hash)
      hash.merge!({
        partner_id: partner_id,
        shopid: shop_id,
        timestamp: Time.now.to_i
      })
    end

    def request_post(url, body, header)
      ap "reqeust start #{body.to_json}"
      fetch_url = URI(url)
      request = Net::HTTP::Post.new(fetch_url, header)
      request.body = body.to_json
      http = Net::HTTP.new(fetch_url.host, fetch_url.port).tap do |o|
        o.use_ssl = true
      end
      ap "request end #{body.to_json}"
      response = http.request(request)
      JSON.parse response.body
    end

    def make_shopee_signature(url, body)
      signature_base = url + '|' + body.to_json
      OpenSSL::HMAC.hexdigest('sha256', key, signature_base)
    end
  end
end
