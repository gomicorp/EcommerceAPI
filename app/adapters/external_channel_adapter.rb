class ExternalChannelAdapter
  self.abstract_class = true

  def initialize(query_params); end

  protected
  def login; end

  public
  # == 적절하게 정제된 데이터를 리턴합니다.
  def products; end
  def orders; end

  protected
  # == 외부 채널의 API 를 사용하여 각 레코드를 가져옵니다.
  def call_products(query); end
  def call_orders(query); end

  protected
  # == call_XXX 로 가져온 레코드를 정제합니다.
  def refine_products(records); end
  def refine_orders(records); end
end