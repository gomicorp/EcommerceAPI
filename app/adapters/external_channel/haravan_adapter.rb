class HaravanAdapter < ExternalChannelAdapter
  attr_reader :query

  # = 사용 가능한 query property (공식 API 문서 기준입니다.)
  # == ids : 상품 id, comma 를 사용해 동시에 여러 상품을 검색할 수 있습니다
  # == limit : 검색 결과로 전달 받는 데이터 갯수 제한
  # == page : 검색할 페이지 number
  # == since_id :
  # == vendor : vendor 명으로 검색, vendor 는 고미의 Brand 개념과 같습니다
  # == handle
  # == product_type : product_type 으로 검색, product_type 은 고미의 Category 개념과 유사합니다.
  # == collection_id
  # == created_at_min/max
  # == updated_at_min/max
  # == published_at_min/max
  # == pubished_status
  # == fields
  def initialize(query_params)
    @query = query_params
  end

  protected
  def login; end

  public
  # == 적절하게 정제된 데이터를 리턴합니다.
  def products
    refine_products(call_products(query))
  end

  def orders
    refine_orders(call_orders(query))
  end

  protected
  # == 외부 채널의 API 를 사용하여 각 레코드를 가져옵니다.
  def call_products(query)

  end

  def call_orders(query)

  end

  protected
  # == call_XXX 로 가져온 레코드를 정제합니다.
  def refine_products(records)
    product_property = []

    records.each do |record|
      product_property << { id: record['id'],
                            title: { 'vn': record['title'], 'en': record['title'], 'ko': record['title'] },
                            channel_name: 'Haravan',
                            brand_name: record['vendor'],
                            variants: refine_product_options(record['variants']) }
    end
  end

  def refine_product_options(variants)
    option_property = []

    variants.each do |variant|
      option_property << { id: variant['id'],
                           price: variant['price'].to_i,
                           name: variant['title'] }
    end

    option_property
  end

  def refine_orders(records)

  end
end