module ExternalChannel
  class TikiAdapter < BaseAdapter
    attr_accessor :default_headers

    # === 사용 가능한 PRODUCT query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    # https://open.tiki.vn/#manage-product
    {
      # = category_id : 상품 카테고리로 검색
      # = active : 상품의 활성화 상태로 검색 ( 1 = active | 0 = inactive)
      # = created_from_date : 상품 생성 시간 >= date yyyy-mm-dd hh:mm:ss
      # = created_to_date : 상품 생성 시간 <= date
      # = updated_from_date : 상품 업데이트 시간 >= date
      # = updated_to_date : 상품 업데이트 시간 <= date
    }

    # === 사용 가능한 Order query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    # https://open.tiki.vn/#order-api-v2
    {
      # = page : 페이지로 검색, page > 0, default = 1
      # = limit : 페이지당 주문 건수, limit > 0
      # = code : order code 로 검색, comma 로 구분
      # = sku : sku 로 검색, comma 로 구분
      # = item_confirmation_status : 수락 상태로 검색
      # = item_inventory_type : 해당 inventory_type 에 속하는 주문 상품을 최소 1개 이상 포함하는 주문 검색
      # = fulfillment_type : fulfillment_type 으로 검색
      # = status : 주문 상태로 검색
      # = include : 기본 주문 정보에 스키마 추가
      # = is_rma : rma 된 주문을 검색
      #   => Search RMA orders - The replacement order for returned products
      # = filter_date_by : 주문 생성일을 전달한 기준을 이용하여 검색
      # = created_from_date : 주문 생성 시간 >= date
      # = created_to_date : 주문 생성 시간 <= date
      # = updated_from_date : 주문 업데이트 시간 >= date
      # = updated_to_date : 주문 업데이트 시간 <= date
      # = order_by : 데이터 정렬
    }

    QUERY_MAPPER = {
      'created'=> %w[created_from_date created_to_date],
      'updated'=> %w[updated_from_date updated_to_date],
    }

    def initialize
      super
      @default_headers = {
        'tiki-api': Rails.application.credentials.dig(:tiki, :connection_parameters),
        'User-Agent': 'Faraday v1.0.1'
      }
    end

    protected

    # == 적절하게 정제된 데이터를 리턴합니다.
    def products(query_hash = {})
      refine_products(call_products(parse_query_hash(QUERY_MAPPER, query_hash)))
    end

    def orders(query_hash = {})
      refine_orders(call_orders(parse_query_hash(QUERY_MAPPER, query_hash)))
    end

    def login; end

    def parse_query_hash(query_mapper, query_hash)
      super
    end

    def date_formatter(utc_time)
      utc_time.strftime('%Y-%m-%d %H:%M:%S')
    end

    # == 외부 채널의 API 를 사용하여 각 레코드를 가져옵니다.
    def call_products(query_hash)
      endpoint = 'https://api.tiki.vn/integration/v1/products'
      call_all(endpoint, query_hash)
    end

    def call_product(product_id)
      endpoint = "https://api.tiki.vn/integration/v1/products/#{product_id}"
      response = request_get(endpoint, {}, default_headers)

      data = JSON.parse response.body
      raise RuntimeError.new(data['error'].to_s) unless data['error'].nil?

      data
    end

    def call_orders(query_hash)
      endpoint = 'https://api.tiki.vn/integration/v2/orders'
      call_all(endpoint, query_hash)
    end

    # == call_XXX 로 가져온 레코드를 정제합니다.
    def refine_products(records)
      product_property = []

      records.each do |record|
        product_property << {
          id: record['super_id'] != 0 ? record['super_id'] : record['master_id'],
          title: record['name'],
          channel_name: 'Tiki',
          brand_name: call_product(record['product_id'])['attributes']['brand']['value'],
          variants: [
            {
              id: record['product_id'],
              price: record['price'].to_i,
              name: record['name']
            }
          ]
        }
      end

      product_property
    end

    def refine_orders(records)
      order_property = []

      records.each do |record|
        order_property << {
            id: record['code'],
            order_number: record['code'],
            order_status: record['status'],
            pay_method: record['payment']['method'],
            channel: 'Tiki',
            ordered_at: record['created_at'].to_time.getutc,
            paid_at: nil,
            billing_amount: record['invoice']['total_seller_income'],
            ship_fee: record['invoice']['shipping_amount_after_discount'],
            variant_ids: record['items'].map{ |variant| [variant['product']['id'], variant['invoice']['quantity'].to_i, variant['invoice']['price'].to_i ] },
            cancelled_status: record['cancel_info'],
            shipping_status: record['shipping']['status'],
            row_data: record.to_json
        }
      end

      order_property
    end

    private

    def call_all(endpoint, query_hash)
      dataset = []
      maximum_page = 100000 # === TODO: 임의의 큰수 10만입니다. 추후에 util로 Integer MAX 등으로 대체해야 합니다.
      query_hash[:page] ||= 1
      
      while query_hash[:page] <= maximum_page
        response = request_get(endpoint, query_hash, default_headers)

        data = JSON.parse response.body
        raise RuntimeError.new(data['error'].to_s) unless data['error'].nil?

        dataset << data['data']     
        maximum_page = data['paging']['total'].to_i || maximum_page
        query_hash[:page] += 1
      end
      dataset.flatten
    end
  end
end
