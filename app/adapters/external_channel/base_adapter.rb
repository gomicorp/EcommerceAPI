module ExternalChannel
  class BaseAdapter

    def initialize; end

    public

    # == 타입에 따라 정제된 데이터를 리턴합니다.
    def get_list(data_type, query={})
      case data_type
      when 'product'
        products(query)
      when 'order'
        orders(query)
      else
        raise NotImplementedError("The Requested Data Type #{data_type} is not Implemented.")
      end
    end

    protected

    # == 토큰이 필요하며, 유효성을 검사해야하는 어댑터
    def check_token_validation; end

    # == 적절하게 정제된 데이터를 리턴합니다.
    def products(query = {}); end
    def orders(query = {}); end

    # == 로그인이 필요한 어댑터
    def login; end

    # == 외부 채널의 API 를 사용하여 각 레코드를 가져옵니다.
    def call_products(query); end
    def call_orders(query); end

    # == call_XXX 로 가져온 레코드를 정제합니다.
    def refine_products(records); end
    def refine_orders(records); end
  end
end
