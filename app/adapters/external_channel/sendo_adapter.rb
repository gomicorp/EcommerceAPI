module ExternalChannel
  class SendoAdapter < ExternalChannelAdapter
    # Product 요청 파라미터
    # {
    #   date_form: yyyy/mm/dd string,
    #   date_to: yyyy/mm/dd string,
    #   product_name: string,
    # }
    #
    # Order 요청 파라미터
    # {
    #   order_date_from: yyyy/mm/dd string
    #   order_date_to: yyyy/mm/dd string
    #   order_status_date_from: yyyy/mm/dd string (주문 변경 일자)
    #   order_status_date_to: yyyy/mm/dd string (주문 변경 일자)
    #   order_status: 주문 상태
    # }

    attr_reader :base_url

    def initialize
      @base_url = "https://open.sendo.vn"
      login
    end

    public

    # == 적절하게 정제된 데이터를 리턴합니다.
    def products(query_hash = {})
      refine_products(call_products(query_hash))
    end

    def orders(query_hash = {})
      refine_orders(call_orders(query_hash))
    end

    # protected

    def login
      api_key = Rails.application.credentials.dig(:sendo, :api,  :key)
      api_password = Rails.application.credentials.dig(:sendo, :api, :password)
      login_url = URI("#{base_url}/login")
      login_body = {shop_key: api_key, secret_key: api_password}
      login_header = {'Content-Type': 'application/json'}
      response = req_post_json(login_url, login_body, login_header)
      data = JSON.parse response.body
      # 새로 발급받은 토큰만 유효하므로 기존 토큰을 대체함.
      @@token = data["result"]["token"]
    end

    # == 외부 채널의 API 를 사용하여 각 레코드를 가져옵니다.
    def call_products(query_hash = {})
      products_url = URI("#{base_url}/api/partner/product/search")
      products_body = {
        token: '',
        page_size: 50
      }.merge(query_hash)
      products_header = {
        'Authorization': "bearer #{@@token}",
        'Content-Type': 'application/json',
      }
      product_ids = request_lists(products_url, products_body, products_header) do |products|
        products["result"]["data"].pluck("id")
      end
      get_all_by_ids(product_ids, "#{base_url}/api/partner/product")
    end

    def call_orders(query_hash = {})
      orders_url = URI("#{base_url}/api/partner/salesorder/search")
      orders_body = {
        token: ''
      }.merge(query_hash)
      orders_header = {
        'Authorization': "bearer #{@@token}",
        'Content-Type': 'application/json',
        'cache-control': 'no-cache'
      }
      request_lists(orders_url, orders_body, orders_header) do |orders|
        orders["result"]["data"]
      end
    end

    # == call_XXX 로 가져온 레코드를 정제합니다.
    def refine_products(products)
      products.map do |product|
        {
          id: product["id"],
          title: product["name"],
          channel_name: 'sendo',
          brand_name: product["brand_name"] || 'not brand',
          variants: form_variants(product)
        }
      end
    end

    def refine_orders(records); end

    # == json으로 Post요청을 날립니다.
    def req_post_json(url, body={}, headers={})
      request = Net::HTTP::Post.new(url)
      request.body = body.to_json

      headers.each_pair do |key, value|
        request[key] = value
      end

      http = Net::HTTP.new(url.host, url.port).tap do |o|
        o.use_ssl = true
      end
      http.request(request)
    end

    # == json으로 Get요청을 날립니다.
    def req_get_json(url, headers={})
      request = Net::HTTP::Get.new(url)
      headers.each_pair do |key, value|
        request[key] = value
      end

      http = Net::HTTP.new(url.host, url.port).tap do |o|
        o.use_ssl = true
      end
      http.request(request)
    end

    # private
    def form_variants(product)
      variants = product["variants"]

      # variants 가 빈배열인 데이터가 있다.
      # 이 경우, default 옵션 데이터를 만들어 줄 필요가 있다.
      return [
        {
          id: product["id"],
          name: 'default',
          price: product["price"]
        }
      ] if variants.empty?

      variants.map do |variant|
        {
          id: variant["variant_sku"],
          name: variant["variant_sku"],
          price: variant["variant_price"]
        }
      end
    end

    def get_all_by_ids(ids, url, query_hash = {})
      header = {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{@@token}"
      }

      ids.map do |id|
        ap id
        query_hash[:id] = id
        req_uri = URI(url_with_query_hash(url, query_hash))
        record = JSON.parse(req_get_json(req_uri, header).body)
        if block_given?
          yield record
        else
          record["result"]
        end
      end
    end

    # == list 에서 모든 데이터를 요청합니다.
    def request_lists(url, body, header)
      body[:token] = ""
      data = []
      while body[:token].nil? == false
        response = req_post_json(url, body, header)
        each_data = JSON.parse response.body
        body[:token] = each_data["result"]["next_token"]
        data << if block_given?
                  yield each_data
                else
                  each_data
                end
        ap data.length
      end
      data.flatten
    end
  end
end