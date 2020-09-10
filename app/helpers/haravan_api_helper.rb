module HaravanApiHelper
  require 'net/http'
  require 'set'


  # == UTC 를 베트남 시간으로 계산하기 위한 메소드입니다.
  def parse_vietnam_datetime(date)
    DateTime.parse(date) + (7/24.0)
  end

  # == type : 원하는 모델 / 'products' or 'orders'
  # == page : 원하는 page
  def get_records(type, url)
    api_key = Rails.application.credentials.dig(:haravan, :api, :key)
    api_password = Rails.application.credentials.dig(:haravan, :api, :password)

    fetch_url = URI(url)
    request = Net::HTTP::Get.new(fetch_url)
    request.basic_auth(api_key, api_password)
    http = Net::HTTP.new(fetch_url.host, fetch_url.port).tap do |o|
      o.use_ssl = true
    end
    response = http.request(request)
    data = JSON.parse response.body
    data[type]
  end

  # == type : 원하는 모델 / 'products' or 'orders'
  # == query_hash: 원하는 query option을 property로 담고 있는 hash
  def generate_query_url(type, query_hash)
    return '' unless query_hash.is_a?(Hash)

    base_url = 'https://gomicorp.myharavan.com/admin'

    query_element =[]
    query_hash.each_pair do |key, value|
      query_element << "#{key}=#{value}"
    end

    "#{base_url}/#{type}.json?#{query_element.join('&')}"
  end

  # == query_hash: 원하는 query option을 property로 담고 있는 hash
  # == type : 원하는 모델 / 'products' or 'orders'
  def get_records_with_query(query_hash, type)
    records = []

    query_hash[:page] = 1
    data = get_records(type, generate_query_url(type, query_hash))

    while data.length > 0
      records << data

      query_hash[:page] += 1
      data = get_records(type, generate_query_url(type, query_hash))
    end

    records.flatten
  end

  module HaravanProduct
    def get_product_by_period(from, to)
      query_hash = {
        :created_at_min => from,
        :created_at_max => to,
        :published_status => 'published'
      }
      get_records_with_query(query_hash, 'products')
    end
  end

  module Order
    def get_order_by_period(from, to)
      query_hash ={
        :created_at_min => from,
        :created_at_max => to
      }
      get_records_with_query(query_hash, 'orders')
    end
  end
end