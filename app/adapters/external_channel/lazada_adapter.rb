module ExternalChannel
  class LazadaAdapter < BaseAdapter
    require 'lazop_api_client'
    require 'selenium-webdriver'

    include Rails.application.routes.url_helpers

    attr_reader :code, :token, :app_key, :app_secret, :order_status, :canceled_status, :shipping_status

    # === 사용 가능한 PRODUCT query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    # https://open.lazada.com/doc/api.htm?spm=a2o9m.11193494.0.0.c55f266b3DH77F#/api?cid=5&path=/products/get
    {
        # = search : 상품 이름 혹은 Seller SKU 를 string 으로 검색
        # = offset : 지정한 갯수의 데이터를 skip
        # = limit : 응답 받을 데이터의 갯수
        # = options : 추가적인 재고 정보를 얻을 수 있음
        #   => This value can be used to get more stock information.
        #   => e.g., Options=1 means contain ReservedStock, RtsStock, PendingStock, RealTimeStock, FulfillmentBySellable.
        # = sku_seller_list : Seller SKU 의 list 로 검색
        # = create_before : 상품 생성 시간 <= date (ISO 8601)
        # = create_after : 상품 생성 시간 >= date (ISO 8601)
        # = update_before : 상품 업데이트 시간 <= date (ISO 8601)
        # = update_after : 상품 업데이트 시간 >= date (ISO 8601)
    }

    # === 사용 가능한 Order query property (공식 API 문서 기준이고, 변경될 가능성이 있습니다)
    # https://open.lazada.com/doc/api.htm?spm=a2o9m.11193494.0.0.c55f266b3DH77F#/api?cid=8&path=/orders/get
    {
        # = status : 주문 상태로 검색
        # = sort_by : 생성 시간과 업데이트 시간을 기준으로 정렬
        # = sort_direction : 오름차순과 내림차순을 결정
        # = offset : 지정한 갯수의 데이터를 skip
        # = limit : 응답 받을 데이터의 갯수
        # = created_before : 주문 생성 시간 <= date (ISO 8601)
        # = created_after : 주문 생성 시간 >= date (ISO 8601)
        # = update_before : 주문 업데이트 시간 <= date (ISO 8601)
        # = update_after : 주문 업데이트 시간 >= date (ISO 8601)
    }

    QUERY_MAPPER = {
      'products'=> {
        'created'=> %w[create_after create_before],
        'updated'=> %w[update_after update_before],
      },
      'orders'=> {
        'created'=> %w[created_after created_before],
        'updated'=> %w[update_after update_before],
      }
    }

    def initialize
      super
      cur_country = Country.send(ApplicationRecord.country_code)
      @token = ExternalChannel::Token.find_or_create_by(country: cur_country,
                                                        channel: Channel.find_by(country: cur_country, name: 'Lazada'))

      @app_key = Rails.application.credentials.dig(:lazada, :api, :app_key)
      @app_secret = Rails.application.credentials.dig(:lazada, :api, :app_secret)
    end

    def set_code(params)
      @code = params[:code]

      get_access_token
    end

    private

    # === TODO:/Users/gomidev/Documents/chromedriver 이 경로로 chrome driver를 깔아줘야 함.
    def get_code
      Selenium::WebDriver::Chrome::Service.driver_path = Rails.application.credentials.dig(:chrome_driver_path)
      options = Selenium::WebDriver::Chrome::Options.new # = 크롬 헤드리스 모드 위해 옵션 설정
      options.add_argument('--disable-extensions')
      options.add_argument('--headless')
      options.add_argument('--disable-gpu')
      options.add_argument('--no-sandbox')

      browser = Selenium::WebDriver.for :chrome, options: options
      browser.navigate.to "https://auth.lazada.com/oauth/authorize?response_type=code&force_auth=true&redirect_uri=#{root_url}external_channels/code&client_id=#{app_key}"

      # = 로그인이 안 되어있는 경우 : form.empty? => true
      form = browser.find_elements(css: 'form[name=form1]')
      if form.empty?
        country_span_area = browser.find_element(css: "#alibaba-login-iframe > .lazop-login #country")
        email_area = browser.find_element(css: "#alibaba-login-iframe > .lazop-login #fm-login-id")
        password_area = browser.find_element(css: "#alibaba-login-iframe > .lazop-login #fm-login-password")

        country_span_area.click

        sleep 2 # = 드롭다운 애니메이션이 있어서 잠시 대기해줍니다.

        vn = browser.find_element(css: "li[value=vn]")
        vn.click

        email_area.send_keys(Rails.application.credentials.dig(:lazada, :seller_center, :email))
        password_area.send_keys(Rails.application.credentials.dig(:lazada, :seller_center, :password))

        submit_button = browser.find_element(css: "#alibaba-login-iframe > .lazop-login #login-submit")
        submit_button.click
      else
        submit_button = browser.find_element(css: "#sub")
        submit_button.click
      end

      sleep 5 # = 정상적으로 submit 을 수행시키기 위해 잠시 대기합니다.
      browser.quit
    end

    def get_access_token
      client = LazopApiClient::Client.new('https://auth.lazada.com/rest', app_key, app_secret)
      request = LazopApiClient::Request.new('/auth/token/create')
      request.add_api_parameter("code", code)
      response = client.execute(request)

      token.update(access_token: response.body['access_token'],
                   access_token_expire_time: DateTime.now + response.body['expires_in'].seconds,
                   refresh_token: response.body['refresh_token'],
                   refresh_token_expire_time: DateTime.now + response.body['refresh_expires_in'].seconds)
    end

    def refreshing_token
      client = LazopApiClient::Client.new('https://auth.lazada.com/rest', app_key, app_secret)
      request = LazopApiClient::Request.new('/auth/token/refresh')
      request.add_api_parameter("refresh_token", token.refresh_token)
      response = client.execute(request)

      token.update(access_token: response.body['access_token'],
                   access_token_expire_time: DateTime.now + response.body['expires_in'].seconds,
                   refresh_token: response.body['refresh_token'],
                   refresh_token_expire_time: DateTime.now + response.body['refresh_expires_in'].seconds)
    end

    def check_token_validation
      get_code
      # if !token.access_token || token.access_token_expired?
      #   if !token.refresh_token || token.refresh_token_expired?
      #     get_code
      #   else
      #     refreshing_token
      #   end
      # end
    end

    public
    # == 적절하게 정제된 데이터를 리턴합니다.
    def products(query_hash = {})
      check_token_validation

      refine_products(call_products(parse_query_hash(QUERY_MAPPER['products'], query_hash)))
    end

    def orders(query_hash = {})
      check_token_validation

      refine_orders(call_orders(parse_query_hash(QUERY_MAPPER['orders'], query_hash)))
    end

    protected
    def login; end

    def date_formatter(utc_time)
      country_zone = ActiveSupport::TimeZone.country_zones('vn')[0]
      time_offset = ActiveSupport::TimeZone[country_zone.name].formatted_offset
      time_diff = time_offset.to_time.hour

      (utc_time.to_datetime - time_diff.hours).iso8601
    end

    def call_products(query_hash)
      response = request_get('/products/get', query_hash)
      response.body['data']['products']
    end

    def call_orders(query_hash)
      response = request_get('/orders/get', query_hash)
      response.body['data']['orders']
    end

    def call_order_items(order_id)
      response = request_get('/order/items/get', { order_id: order_id })
      response.body['data']
    end

    def call_ovo_order(order_id)
      response = request_get('/orders/ovo/get', { tradeOrderIds: order_id })
      response.body['result']
    end

    def request_get(endpoint, params)
      client = LazopApiClient::Client.new('https://api.lazada.vn/rest', app_key, app_secret)
      request = LazopApiClient::Request.new(endpoint,'GET')

      params.each { |k, v| request.add_api_parameter(k.to_s, v.to_s) }

      client.execute(request, token.access_token)
    end

    def refine_products(records)
      product_property = []

      records.each do |record|
        product_property << {
            id: record['item_id'],
            title: record['attributes']['name'],
            channel_name: 'Lazada',
            brand_name: record['attributes']['brand'],
            variants: refine_product_options(record['skus'])
        }
      end if records.present?

      product_property
    end

    def refine_product_options(skus = [])
      option_property = []

      skus.each do |sku|
        option_property << {
            id: sku['SellerSku'],
            price: sku['special_price'],
            name: sku['_compatible_variation_'] || sku['ShopSku']
        }
      end

      option_property
    end

    # = Bọt Rửa Mặt FarmSkin Facial Cleansing Foam-Hương:Grape
    # = 627113002

    # = order_status : [unpaid, pending, canceled, ready_to_ship, delivered, returned, shipped, failed]
    # = canceled_status : [canceled]
    # = shipping_status : [ready_to_ship, delivered, returned, shipped]
    def refine_orders(records)
      @order_status ||= %w[unpaid pending canceled failed]
      @canceled_status ||= %w[canceled]
      @shipping_status ||= %w[ready_to_ship delivered returned shipped INFO_ST_DOMESTIC_RETURN_WITH_LAST_MILE_3PL]
      order_property = []

      records.each do |record|
        call_order_items(record['order_id']).each_with_index do |order_item, index|
          order_property << {
            id: "#{record['order_id']}-#{index}",
            order_number: record['order_number'],
            receiver_name: receiver_name(record),
            order_status: order_item['status'],
            pay_method: record['payment_method'],
            channel: 'Lazada',
            ordered_at: record['created_at'].to_time.getutc,
            paid_at: paid_at(call_ovo_order(record['order_id'])),
            billing_amount: record['price'].to_i + record['shipping_fee'],
            ship_fee: record['shipping_fee'],
            cancelled_status: canceled_status.include?(order_item['status']) ? order_item['status'] : nil,
            variant_ids: [[order_item['sku'].to_s, 1, order_item['item_price'].to_i]],
            shipping_status: order_item['status'] ? order_item['status'] : nil,
            payment_status: paid_at(call_ovo_order(record['order_id'])) ? 'paid' : 'pending'
          }
        end
      end if records.present?

      order_property
    end

    def receiver_name(record)
      if record['address_shipping'].any?
        first_name = record['address_shipping']['first_name']
        last_name = record['address_shipping']['last_name']

        if first_name && last_name
          first_name + " " + last_name
        elsif first_name
          first_name
        elsif last_name
          last_name
        end
      else
        ""
      end
    end

    def paid_at(ovo_order)
      if ovo_order['tradeOrders'].any? && ovo_order['tradeOrders'][0]['paidTime']
        ovo_order['tradeOrders'][0]['paidTime'].to_time.getutc
      else
        nil
      end
    end
  end
end
