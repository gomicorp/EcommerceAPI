module HaravanApiHelper
  require 'net/http'
  require 'set'

  @api_key = Rails.application.credentials.dig(:haravan, :api, :key)
  @api_password = Rails.application.credentials.dig(:haravan, :api, :password)

  # == UTC 를 베트남 시간으로 계산하기 위한 메소드입니다.
  def parse_vietnam_datetime(date)
    DateTime.parse(date) + (7/24.0)
  end

  def compare(left, right)
    left < right
  end

  def set_url(type, from, to, page)
    "https://gomicorp.myharavan.com/admin/#{type}.json?created_at_min=#{from}&created_at_max=#{to}&page=#{page}"
  end

  # == type : 원하는 모델 / 'products' or 'orders'
  # == page : 원하는 page
  def get_records(type, url)
    fetch_url = URI(url)
    request = Net::HTTP::Get.new(fetch_url)
    request.basic_auth(@api_key, @api_password)
    http = Net::HTTP.new(fetch_url.host, fetch_url.port).tap do |o|
      o.use_ssl = true
    end
    response = http.request(request)
    data = JSON.parse response.body
    data[type]
  end

  def get_records_by_period(from, to, type)
    records = []
    page = 1
    url = "https://gomicorp.myharavan.com/admin/#{type}.json?created_at_min=#{from}&created_at_max=#{to}&page=#{page}"

    data = get_records(type, url)
    while data.length > 0
      records << data

      page += 1
      data = get_records(type, url)
    end
    records.flatten
  end

  module Product

    def get_product_by_period(from, to)
      get_records_by_period(from, to, 'products')
    end
  end

  module Order

    def get_order_by_period(from, to)
      get_records_by_period(from, to, 'orders')
    end
  end
end