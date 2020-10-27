module ExternalChannel
  class TikiAdapter < ExternalChannelAdapter
    attr_reader :connection_parameters

    # === 사용 가능한 PRODUCT query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    # https://open.tiki.vn/#manage-product
    {
      # = category_id : 상품 카테고리로 검색
      # = active : 상품의 활성화 상태로 검색 ( 1 = active | 0 = inactive)
      # = created_from_date : 상품 생성 시간 >= date
      # = created_to_date : 상품 생성 시간 <= date
      # = updated_from_date : 상품 업데이트 시간 >= date
      # = updated_to_date : 상품 업데이트 시간 <= date
    }

    # === 사용 가능한 Order query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    # https://open.tiki.vn/#order-api-v2
    {
      # = page :
    }

    def initialize
      @connection_parameters = Rails.application.credentials.dig(:tiki, :connection_parameters)
    end

    public
    # == 적절하게 정제된 데이터를 리턴합니다.
    def products(query_hash = {})
      refine_products(call_products(query_hash))
    end

    def orders(query_hash = {})
      refine_orders(call_orders(query_hash))
    end

    protected
    def login; end

    # == 외부 채널의 API 를 사용하여 각 레코드를 가져옵니다.
    def call_products(query_hash)
      base_url = 'https://api.tiki.vn/integration/v1/products'
      response = Faraday.get(base_url, query_hash, { 'tiki-api': connection_parameters })

      data = JSON.parse response.body

      data['data']
    end

    def call_orders(query_hash)
      base_url = 'https://api.tiki.vn/integration/v2/orders'
      response = Faraday.get(base_url, query_hash, { 'tiki-api': connection_parameters })

      data = JSON.parse response.body

      data['data']
    end

    # == call_XXX 로 가져온 레코드를 정제합니다.
    def refine_products(records)
      product_property = []

      records.each do |record|
        product_property << {
          id: record['super_id'],
          title: record['name'],
          channel_name: 'Tiki',
          brand_name: refine_brand(record['product_id']),
          options: [
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

    def refine_brand(product_id)
      base_url = "https://api.tiki.vn/integration/v1/products/#{product_id}"
      response = Faraday.get(base_url, {}, { 'tiki-api': connection_parameters })

      data = JSON.parse response.body

      data['attributes']['brand']['value']
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
            ordered_at: record['created_at'].to_time,
            paid_at: nil,
            billing_amount: record['invoice']['total_seller_income'],
            ship_fee: record['invoice']['shipping_amount_after_discount'],
            variant_ids: record['items'].map{ |variant| [variant['product']['id'], variant['invoice']['quantity'].to_i] },
            cancelled_status: record['cancel_info'],
            shipping_status: record['shipping']['status']
        }
      end

      order_property
    end
  end
end