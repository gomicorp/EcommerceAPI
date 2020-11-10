module ExternalChannel
  class ShopeeAdapter < BaseAdapter
    public
    attr_accessor :base_url

    private
    attr_accessor :key, :default_body, :default_headers

    # === 사용 가능한 PRODUCT query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    # === from 과 to 사이 최대 기간은 15일임. 받으려면 15일 간격으로 잘라서 받아야 함.
    {
      # = update_time_from
      # = update_time_to
      # = pagination_offset : default 0
      # = pagination_entries_per_page : default 10, max 100
    }

    # === 사용 가능한 Order query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    {
      # = order_status: ALL/UNPAID/READY_TO_SHIP/COMPLETED/IN_CANCEL/CANCELLED/TO_RETURN, default: ALL
      # = create_time_from
      # = create_time_to
      # = pagination_entries_per_page: default 0
      # = pagination_offset: default 100, max 100
    }

    public
    def initialize
      @base_url = 'https://partner.shopeemobile.com/api/v1'
      @key = Rails.application.credentials.dig(:shopee, :api, :key)

      shop_id = Rails.application.credentials.dig(:shopee, :api, :shopid)
      partner_id = Rails.application.credentials.dig(:shopee, :api, :partner_id)

      @default_headers = {
        'Content-Type': 'application/json'
      }
      @default_body = {
        partner_id: partner_id,
        shopid: shop_id,
      }
    end

    # protected
    # == 적절하게 정제된 데이터를 리턴합니다.
    def products(query_hash = {})
      refine_products(call_products(query_hash))
    end

    def orders(query_hash = {})
      refine_orders(call_orders(query_hash))
    end

    def login; end

    # == 외부 채널의 API 를 사용하여 각 레코드를 가져옵니다.
    def call_products(query_hash = {})
      endpoint = "#{base_url}/items/get"
      default_body['timestamp'] = Time.now.to_i

      call_list(endpoint, default_body.merge(query_hash))
        .map{ |data| call_product_by_ids(data['items'].pluck('item_id')) }
        .flatten.pluck('item_id')
    end

    def call_orders(query_hash = {})
      query_hash[:order_status] ||= 'ALL'

      endpoint = "#{base_url}/orders/get"
      default_body['timestamp'] = Time.now.to_i

      call_list(endpoint, default_body.merge(query_hash))
        .map{ |data| call_product_by_ids(data['orders'].pluck('ordersn')) }
        .flatten
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

    def refine_orders(orders)
      orders.map do |order|
        {
            id: order['ordersn'],
            order_number: order['ordersn'],
            order_status: order['order_status'],
            pay_method: order['payment_method'],
            channel: 'shopee',
            ordered_at: Time.new(order['create_time']).getutc,
            paid_at: paid_time(order['pay_time']),
            billing_amount: order['escrow_amount'],
            ship_fee: order['actual_shipping_cost'],
            variants_ids: variants(order['items']),
            canceled_status: cancel_status(order['order_status']),
            shipping_status: shipping_status(order['order_status'])
        }
      end
    end

    private

    # === shopee 에서 데이터를 가져오는 부분
    def call_product_by_ids(ids)
      endpoint = "#{base_url}/item/get"
      call_each_by_ids(ids, endpoint, 'item') do |id|
        {item_id: id}
      end
    end

    def call_order_by_sn(sn)
      endpoint = "#{base_url}/orders/detail"
      # === shopee 에서 받을 수 있는 order 의 개수를 50개로 제한함.
      call_each_by_ids(sn.each_slice(50), endpoint, 'orders') do |order_sns|
        { ordersn_list: order_sns }
      end
    end

    # = body 를 의미하는 block 을 받아, 모든 id에 대해 post 요청을 보내고 타겟에 대한 묶음을 전달하는 함수.
    def call_each_by_ids(ids, endpoint, target)
      ids.map do |id|
        default_body['timestamp'] = Time.now.to_i

        if block_given?
          default_headers['Authorization'] = make_shopee_signature(endpoint, default_body.merge(yield id))
          response = request_post(endpoint, default_body.merge(yield id), default_headers)

          response[target]
        end
      end
    end

    # === 쇼피의 데이터 중 more 이라는 데이터가 있는 것들은 pagination을 따로 하지 않고, more로만 붙여 준다.
    # === order와 product의 list요청에는 모두 more이라는 데이터가 확인되어, 앞으로 user등의 데이터가 추가되어도 사용될 것이라 기대하고 설정함.
    # === 암것도 모드고 while 문 내에서 more이 false가 될 때까지 부름.
    def call_list(endpoint, body)
      more = true
      body[:pagination_offset] ||= 0
      body[:pagination_entries_per_page] ||= 100

      response_data = []
      while more do
        default_headers['Authorization'] = make_shopee_signature(endpoint, body)
        response = request_post(endpoint, body, default_headers)
        more = response['more']
        body[:pagination_offset] += body[:pagination_entries_per_page]

        response_data << response
      end

      response_data
    end

    def request_post(endpoint, body, header)
      Faraday.new(endpoint) do |conn|
        conn.request(:retry, max: 5, interval: 1, exceptions: ['Timeout::Error'])

        response = conn.post do |req|
          req.headers.merge!(header)
          req.body = body.to_json
        end

        return JSON.parse(response.body)
      end
    end

    def make_shopee_signature(endpoint, body)
      signature_base = endpoint + '|' + body.to_json
      OpenSSL::HMAC.hexdigest('sha256', key, signature_base)
    end

    ### === Shopee 에서 가져온 데이터를 정제하는 부분

    # === product data refine

    # === TODO: No Brand인 경우 베트남 측에서 관리하지 않은 브랜드로 보인다. 이것을 어떻게 처리할지 논의가 필요하다.
    # === 우려되는 사항은 다음과 같다.
    # === 1. 가격등 브랜드와 관련 없는 정보가 바뀔 경우 브랜드를 다시 No Brand로 설정 할 수 있다.
    def refine_brand_name(attr)
      brand_attr = attr.find{|attr| attr['attribute_name'] == "Thương hiệu"}
      brand_attr['attribute_value']
    end

    def refine_variants(product)
      variants = product['variations']

      # === variants 가 없으면 product 를 참조 해야 한다.
      return [{
                  id: product['item_id'],
                  price: product['price'],
                  name: 'default'
              }] if variants.empty?

      variants.map do |variant|
        {id: variant['variation_id'], price: variant['price'], name: variant['name']}
      end
    end

    #=== order 데이터 refine

    def paid_time(pay_time)
      pay_time ? Time.new(pay_time).getutc : nil
    end

    def cancel_status(order_status)
      order_status == 'CANCEL' ? order_status : nil
    end

    def shipping_status(order_status)
      %w(READY_TO_SHIP RETRY_SHIP SHIPPED).include? order_status ? order_status : nil
    end

    def variants(variants)
      variants.map do |variant|
        [variant['variation_id'] || variant['item_id'], variant['variation_quantity_purchased']]
      end
    end
  end
end
