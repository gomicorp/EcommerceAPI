class HaravanAdapter < ExternalChannelAdapter
  attr_reader :query

  # = 사용 가능한 query property (공식 API 문서 기준입니다.)
  # == ids
  # == limit
  # == page
  # == since_id
  # == vendor
  #
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
      # == Brand 가 없을 경우를 대비한 에러 핸들링 필요
      vendor_name = record["vendor"].gsub('&amp;', '&').to_json.gsub('&amp;', '&').gsub(/[\\\*\+\?\()\|]/, '\\\\\\')
      @brand = Brand.where("JSON_EXTRACT(name, '$.vi') LIKE ?", "#{vendor_name}").first

      product_property << { haravan_id: record['id'],
                            brand_id: @brand.id,
                            running_status: 'pending',
                            title: { 'vn': record['title'], 'en': record['title'], 'ko': record['title'] },
                            country: Country.vn,
                            variants: refine_product_options(record['variants']) }
    end
  end

  def refine_product_options(variants)
    option_property = []
    channel = Channel.find_by_name('Haravan')

    variants.each do |variant|
      option_property << { name: variant['title'],
                           channel: channel,
                           channel_id: channel.id,
                           channel_code: variant['id'],
                           additional_price: variant['price'].to_i }
    end

    option_property
  end

  def refine_orders(records)

  end
end