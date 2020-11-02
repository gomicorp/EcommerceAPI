module ExternalChannel
  class ShopeeAdapter < BaseAdapter
    attr_reader :connection_parameters

    # === 사용 가능한 PRODUCT query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    #{
    #}


    # === 사용 가능한 Order query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    # https://open.tiki.vn/#order-api-v2
    #{
    #}

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
    end

    def call_orders(query_hash)
    end
    # == call_XXX 로 가져온 레코드를 정제합니다.
    def refine_products(records)
    end

    def refine_brand(product_id)
    end

    def refine_orders(records)
    end

    private
  end
end
