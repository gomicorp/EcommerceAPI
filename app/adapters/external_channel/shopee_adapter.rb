module ExternalChannel
  class ShopeeAdapter < BaseAdapter
    attr_accessor :base_url

    private

    attr_accessor :key, :default_body, :default_headers, :product_query_mapper, :order_query_mapper

    # === 사용 가능한 PRODUCT query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    # === from 과 to 사이 최대 기간은 15일임. 받으려면 15일 간격으로 잘라서 받아야 함.
    # === TODO: 쇼피는 요청시 15일 간격으로 보내야함.
    {
      # = update_time_from: 1472774528 (time stamp) => Time.new(yyyy, m, d).to_i
      # = update_time_to: 1472774528 (time stamp) => Time.new(yyyy, m, d).to_i
      # = pagination_offset : default 0
      # = pagination_entries_per_page : default 10, max 100
    }

    # === 사용 가능한 Order query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    {
      # = order_status: ALL/UNPAID/READY_TO_SHIP/COMPLETED/IN_CANCEL/CANCELLED/TO_RETURN, default: ALL
      # = create_time_from: 1472774528 (time stamp) => Time.new(yyyy, m, d).to_i
      # = create_time_to: 1472774528 (time stamp) => Time.new(yyyy, m, d).to_i
      # = pagination_entries_per_page: default 0
      # = pagination_offset: default 100, max 100
    }

    public

    def initialize
      super
      @base_url = 'https://partner.shopeemobile.com/api/v1'
      @key = Rails.application.credentials.dig(:shopee, :api, :key)

      shop_id = Rails.application.credentials.dig(:shopee, :api, :shopid)
      partner_id = Rails.application.credentials.dig(:shopee, :api, :partner_id)

      @default_headers = {
        'Content-Type': 'application/json'
      }
      @default_body = {
        partner_id: partner_id,
        shopid: shop_id
      }
      @product_query_mapper = {
        'updated'=> %w[update_time_from update_time_to],
      }
      @order_query_mapper = {
        'created'=> %w[create_time_from create_time_to],
      }
    end

    protected

    # == 적절하게 정제된 데이터를 리턴합니다.
    def products(query_hash = {})
      refine_products(call_products(parse_query_hash(product_query_mapper, query_hash)))
    end

    def orders(query_hash = {})
      refine_orders(call_orders(parse_query_hash(order_query_mapper, query_hash)))
    end

    def parse_query_hash(query_mapper, query_hash)
      @request_type = query_hash['key'] || 'updated'
      super
    end

    def date_formatter(utc_time)
      utc_time.to_datetime.new_offset(0).to_i
    end

    # == 외부 채널의 API 를 사용하여 각 레코드를 가져옵니다.
    def call_products(query_hash = {})
      endpoint = "#{base_url}/items/get"
      default_body['timestamp'] = Time.now.to_i

      call_list(endpoint, default_body.merge(query_hash), 'product')
        .map { |data| call_product_by_ids(data['items'].pluck('item_id')) }
        .flatten
    end

    def call_orders(query_hash = {})
      query_hash[:order_status] ||= 'ALL'

      endpoint = "#{base_url}/orders/get"
      default_body['timestamp'] = Time.now.to_i

      call_list(endpoint, default_body.merge(query_hash), 'order')
        .map { |data| call_order_by_sn(data['orders'].pluck('ordersn')) }
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
          id: (order['ordersn']).to_s,
          order_number: order['ordersn'],
          order_status: order['order_status'],
          pay_method: order['payment_method'],
          channel: 'shopee',
          ordered_at: Time.at(order['create_time']).getutc,
          paid_at: paid_time(order['pay_time']),
          billing_amount: order['escrow_amount'],
          ship_fee: order['actual_shipping_cost'],
          variant_ids: variants(order['items']),
          cancelled_status: cancel_status(order['order_status']),
          shipping_status: shipping_status(order['order_status'])
        }
      end
    end

    private

    # === 쇼피의 데이터 중 more 이라는 데이터가 있는 것들은 pagination을 따로 하지 않고, more로만 붙여 준다.
    # === order와 product의 list요청에는 모두 more이라는 데이터가 확인되어, 앞으로 user등의 데이터가 추가되어도 사용될 것이라 기대하고 설정함.
    # === 암것도 모드고 while 문 내에서 more이 false가 될 때까지 부름.
    def call_list(endpoint, body, data_type)
      more = true
      body[:pagination_offset] ||= 0
      body[:pagination_entries_per_page] ||= 100
      from, to = time_symbol(data_type)

      update_from = body[from]

      response_data = []
      while body[to] > update_from
        update_limit = body[to] - 15.days.to_i
        body[from] = update_limit > update_from ? update_limit : update_from

        while more
          default_headers['Authorization'] = make_shopee_signature(endpoint, body)
          response = request_post(endpoint, body, default_headers)
          data = JSON.parse(response.body)
          raise RuntimeError.new(data['error'].to_s) if data.key?('error')

          more = data['more']
          body[:pagination_offset] += body[:pagination_entries_per_page]
          response_data << data 
        end

        body[to] = body[from]
        more = true
      end

      response_data
    end

    def time_symbol(data_type)
      case data_type
      when 'product'
        product_query_mapper[@request_type]
      when 'order'
        order_query_mapper[@request_type]
      end
    end

    # === shopee 에서 데이터를 가져오는 부분
    def call_product_by_ids(ids)
      endpoint = "#{base_url}/item/get"
      call_each_by_ids(ids, endpoint, 'item') do |id|
        { item_id: id }
      end
    end

    def call_order_by_sn(sn)
      endpoint = "#{base_url}/orders/detail"
      # === shopee 에서 받을 수 있는 order 의 개수를 50개로 제한함.
      call_each_by_ids(sn.each_slice(50), endpoint, 'orders') do |order_sns|
        { ordersn_list: order_sns }
      end
    end

    # = TODO: 레포의 #103 이슈에 내용 담김
    # = body 를 의미하는 block 을 받아, 모든 id에 대해 post 요청을 보내고 타겟에 대한 묶음을 전달하는 함수.
    def call_each_by_ids(ids, endpoint, target)
      return [] unless block_given?

      ids.map do |id|
        default_body['timestamp'] = Time.now.to_i

        default_headers['Authorization'] = make_shopee_signature(endpoint, default_body.merge(yield id))
        response = request_post(endpoint, default_body.merge(yield id), default_headers)
        data = JSON.parse(response.body)
        raise RuntimeError.new(data['error'].to_s) if data.key?('error')

        data[target]
      end
    end

    def make_shopee_signature(endpoint, body)
      signature_base = "#{endpoint}|#{body.to_json}"
      OpenSSL::HMAC.hexdigest('sha256', key, signature_base)
    end

    ### === Shopee 에서 가져온 데이터를 정제하는 부분

    # === product data refine

    # === TODO: No Brand인 경우 베트남 측에서 관리하지 않은 브랜드로 보인다. 이것을 어떻게 처리할지 논의가 필요하다.
    # === 우려되는 사항은 다음과 같다.
    # === 1. 가격등 브랜드와 관련 없는 정보가 바뀔 경우 브랜드를 다시 No Brand로 설정 할 수 있다.
    def refine_brand_name(attrs)
      brand_attr = attrs.find { |attr| attr['attribute_name'].downcase == 'Thương hiệu'.downcase }
      brand_attr['attribute_value']
    end

    def refine_variants(product)
      variants = product['variations']

      # === variants 가 없으면 product 를 참조 해야 한다.
      if variants.empty?
        return [{
          id: (product['item_id']).to_s,
          price: product['price'],
          name: 'default'
        }]
      end

      variants.map do |variant|
        { id: variant['variation_id'], price: variant['price'], name: variant['name'] }
      end
    end

    #=== order 데이터 refine

    def paid_time(pay_time)
      pay_time ? Time.at(pay_time).getutc : nil
    end

    def cancel_status(order_status)
      order_status == 'CANCEL' ? order_status : nil
    end

    def shipping_status(order_status)
      %w[READY_TO_SHIP RETRY_SHIP SHIPPED].include?(order_status) || nil
    end

    def variants(variants)
      variants.map do |variant|
        variant_id = variant['variation_id']
        variant_id = variant['item_id'] if variant_id.zero?
        [variant_id, variant['variation_quantity_purchased'], variant['variation_discounted_price'].to_i]
      end
    end
  end
end
