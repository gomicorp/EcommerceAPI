module Haravan
  module ApiService
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

      # == 상품 불러오기 및 저장
      def save_haravan_products(from, to)
        ActiveRecord::Base.transaction do
          begin
            haravan_products = get_product_by_period(from, to)
            haravan_products.each do |haravan_product|
              extract_data(haravan_product)
              save_product
              save_product_options
            end
          end
        rescue ActiveRecord::ActiveRecordError => e
          # 이곳은 깨졌을 때만 실행되는 에러 핸들링 구역입니다.
          @errors = e
          ap @errors
          return false
        end

      end

      private

      @product_id
      @title
      @variants
      @brand
      @product

      def get_product_by_period(from, to)
        query_hash = {
            :created_at_min => from,
            :created_at_max => to,
            :published_status => 'published'
        }
        get_records_with_query(query_hash, 'products')
      end

      # == 데이터 추출
      # parse haravan raw data to make the products and product options
      def extract_data(haravan_product)
        @product_id = haravan_product["id"]
        @title = haravan_product["title"]
        @variants = haravan_product["variants"]
        @brand = ::Brand.where("JSON_EXTRACT(name, '$.vi') LIKE ?", "\"#{haravan_product["vendor"]}\"").first
      end

      # == 상품페이지를 저장
      # Product page saver
      def save_product
        @product = ::Product.find_or_initialize_by(haravan_id: @product_id)
        @product.assign_attributes(brand_id: @brand.id,
                                   running_status: 'pending',
                                   title: {'vn': @title, 'en': @title, 'ko': @title},
                                   country: Country.vn)
        # @product.assign_attributes(title: product_data["title"].to_h)
        @product.save!
      end

      # == 상품 옵션을 저장
      # Save Product Options that reveal on product page.
      def save_product_options
        product_option_group = @product.option_groups.first_or_create
        channel = Channel.find_by_name('Haravan')

        @variants.each do |option|
          product_option = ProductOption.find_by(channel_code: option['id'])
          if product_option
            product_option.update!(name: option['title'])
          else
            product_option_group.options << ProductOption.new(name: option['title'],
                                                              channel: channel,
                                                              channel_id: channel.id,
                                                              channel_code: option['id'])
          end
        end
      end
    end

    module HaravanOrder
      def get_order_by_period(from, to)
        query_hash ={
            :created_at_min => from,
            :created_at_max => to
        }
        get_records_with_query(query_hash, 'orders')
      end
    end
  end
end