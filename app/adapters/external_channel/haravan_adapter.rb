class HaravanAdapter < ExternalChannelAdapter
  attr_reader :query

  # === 사용 가능한 PRODUCT query property (공식 API 문서 기준입니다)
  # https://docs.haravan.com/blogs/api-reference/1000018172-product
  # === 의미 파악이 어려운 경우에는 원문을 추가로 달아두었습니다.
  #
  # = ids : 상품 id, comma 를 사용해 동시에 여러 상품을 검색할 수 있습니다
  # = limit : 검색 결과로 전달 받는 데이터 갯수 제한
  # = page : 검색할 페이지 number
  # = since_id : 특정 id 이후의 상품들을 검색하는 것으로 "추측" 됩니다
  #   => Restrict results to after the specified ID
  # = vendor : vendor 명으로 검색, vendor 는 고미의 Brand 개념과 같습니다
  # = handle : 상품 title 을 이용해 자동으로 생성되는 인간 친화적 고유 문자열이라고 합니다..
  #   => 'A human-friendly unique string for the Product automatically generated from its title. They are used by the Liquid templating language to refer to objects.'
  # = product_type : product_type 으로 검색, product_type 은 고미의 Category 개념과 유사합니다
  # = collection_id :
  # = created_at_min & created_at_max : 데이터 생성 시간을 기준으로 특정 시점 이전/이후 검색이 가능합니다
  # = updated_at_min & updated_at_max : 데이터 업데이트 시간을 기준으로 특정 시점 이전/이후 검색이 가능합니다
  # = published_at_min & published_at_max : 상품이 개시된 시간을 기준으로 특정 시점 이전/이후 검색이 가능합니다
  # = published_status : 상품 개시 상태로 검색이 가능합니다
  # = fields : response 데이터 중 특정 스키마만 골라서 볼 수 있습니다
  #
  # === 사용 가능한 Order query property (공식 API 문서 기준입니다)
  # https://docs.haravan.com/blogs/api-reference/1000018025-order#show
  def initialize(query_params)

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
                            options: refine_product_options(record['variants']) }
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
    order_property = []

    records.each do |record|
      order_property << { id: record['id'],
                          order_number: record['name'],
                          order_status: record['financial_status'],
                          pay_method: record['gateway'],
                          channel: record['resource'],
                          ordered_at: record['created_at'].to_time,
                          paid_at: record['fulfillments'].any? ? record['fulfillments'][0]['cod_paid_date'].to_time : record['created_at'].to_time,
                          billing_amount: record['total_price'].to_i,
                          ship_fee: record['shipping_lines'].inject(0){ |sum, line| sum + line['price'].to_i },
                          variant_ids: record['line_items'].map{ |variant| variant['id'] },
                          cancelled_status: record['cancelled_status'],
                          shipping_status: record['fulfillments']['status'] }
    end
  end
end