class ExternalChannelAdapter

  def initialize; end

  public
  # == 적절하게 정제된 데이터를 리턴합니다.
  def products(query = {}); end
  def orders(query = {}); end

  protected
  def login; end

  # == 외부 채널의 API 를 사용하여 각 레코드를 가져옵니다.
  def call_products(query); end
  def call_orders(query); end

  # == url에 query를 부착해 줍니다.
  def url_with_query_hash(base_url, query_hash)
    query_element = query_hash.map {|key, value| "#{key}=#{value}"}
    "#{base_url}?#{query_element.join('&')}"
  end

  # == call_XXX 로 가져온 레코드를 정제합니다.
  def refine_products(records); end
  def refine_orders(records); end
end