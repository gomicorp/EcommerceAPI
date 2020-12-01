module ExternalChannel
  class SendoAdapter < BaseAdapter
    # Product 요청 파라미터
    # {
    #   date_from: yyyy/mm/dd string,
    #   date_to: yyyy/mm/dd string,
    #   product_name: string,
    # }
    #
    # Order 요청 파라미터
    # {
    #   order_date_from: yyyy/mm/dd string
    #   order_date_to: yyyy/mm/dd string
    #   order_status_date_from: yyyy/mm/dd string (주문 변경 일자)
    #   order_status_date_to: yyyy/mm/dd string (주문 변경 일자)
    #   order_status: 주문 상태
    # }

    attr_reader :base_url, :default_headers, :token

    def initialize
      super
      @base_url = 'https://open.sendo.vn'
      @token = ExternalChannel::Token.find_or_create_by(country: Country.vn,
                                                      channel: Channel.find_by(name: 'Sendo'))

      @default_headers = {
        'Content-Type': 'application/json'
      }
    end

    protected

    def check_token_validation
      login if !token.auth_token || @token.auth_token_expired?
    end

    # query로 들어오는 값을 지원하는 방식에 맞게 수정합니다.

    # === sendo는 데이터 형식에 따라 query를 리턴하는 방식이 다릅니다.
    # === 따라서 curring하는 형식으로 처리했습니다.
    def parse_query_hash(data_type)
      case data_type
      when 'product'
        ->(query) { parse_query_on_product(default_query(query)) }
      when 'order'
        ->(query) { parse_query_on_order(default_query(query)) }
      end
    end

    # == 적절하게 정제된 데이터를 리턴합니다.
    def products(query_hash = {})
      check_token_validation

      refine_products(call_products(parse_query_hash('product').call(query_hash)))
    end

    def orders(query_hash = {})
      check_token_validation

      refine_orders(call_orders(parse_query_hash('order').call(query_hash)))
    end

    def login
      api_key = Rails.application.credentials.dig(:sendo, :api, :key)
      api_password = Rails.application.credentials.dig(:sendo, :api, :password)
      login_url = URI("#{base_url}/login")
      login_body = { shop_key: api_key, secret_key: api_password }

      response = request_post(login_url, login_body, default_headers)
      data = JSON.parse(response.body)

      token.update(auth_token: data['result']['token'],
                   auth_token_expire_time: data['result']['expires'].to_datetime)
    end

    # == 외부 채널의 API 를 사용하여 각 레코드를 가져옵니다.
    def call_products(query_hash = {})
      products_url = URI("#{base_url}/api/partner/product/search")
      products_body = {
        token: '',
        page_size: 50
      }.merge(query_hash)
      products_header = {
        'Authorization': "bearer #{token.auth_token}",
        'Content-Type': 'application/json'
      }
      product_ids = request_lists(products_url, products_body, products_header) do |products|
        products['result']['data'].pluck('id')
      end
      get_all_by_ids(product_ids, "#{base_url}/api/partner/product")
    end

    def call_orders(query_hash = {})
      orders_url = URI("#{base_url}/api/partner/salesorder/search")
      orders_body = {
        token: ''
      }.merge(query_hash)
      orders_header = {
        'Authorization': "bearer #{token.auth_token}",
        'Content-Type': 'application/json',
        'cache-control': 'no-cache'
      }
      request_lists(orders_url, orders_body, orders_header) do |orders|
        orders['result']['data']
      end
    end

    # == call_XXX 로 가져온 레코드를 정제합니다.
    def refine_products(products)
      products.map do |product|
        {
          id: product['id'],
          title: product['name'],
          channel_name: 'sendo',
          brand_name: product['brand_name'] || 'not brand',
          variants: form_variants(product)
        }
      end
    end

    def refine_orders(orders)
      orders.map do |order|
        sales_data = order['sales_order']
        sales_details = order['sku_details']
        {
          id: sales_data['order_number'].to_s,
          order_number: sales_data['order_number'],
          billing_amount: sales_data['total_amount_buyer'],
          variant_ids: sales_details.map { |option| [ option['sku'], option['quantity'].to_i, option['price'].to_i ] },
          order_status: map_order_status(sales_data['order_status']),
          cancelled_status: cancelled_status(sales_data['order_status']),
          shipping_status: shipping_status(sales_data['order_status']),
          pay_method: map_pay_method(sales_data['payment_method']),
          paid_at: paid_at(sales_data),
          channel: 'sendo',
          ordered_at: Time.at(sales_data['order_date_time_stamp']).getutc,
          ship_fee: sales_data['total_amount_buyer'] - sales_data['total_amount']
        }
      end
    end

    private

    ### === 요청 query데이터를 parsing하는 로직입니다.

    def parse_query_on_product(query_hash)
      update_from = query_hash[:updated_from].to_datetime
      update_to = query_hash[:updated_to].to_datetime
      {
        date_from: "#{update_from.year}/#{update_from.month}/#{update_from.day}",
        date_to: "#{update_to.year}/#{update_to.month}/#{update_to.day}"
      }
    end

    def parse_query_on_order(query_hash)
      update_from = query_hash[:updated_from].to_datetime
      update_to = query_hash[:updated_to].to_datetime
      {
        order_date_from: "#{update_from.year}/#{update_from.month}/#{update_from.day}",
        order_date_to: "#{update_to.year}/#{update_to.month}/#{update_to.day}"
      }
    end
    
    def default_query(query_hash)
      query_hash[:updated_from] ||= Time.now - 1.days
      query_hash[:updated_to] ||= Time.now
      query_hash
    end

    ### === 데이터를 불러오는 로직입니다.

    def get_all_by_ids(ids, url, query_hash = {})
      header = {
        'Content-Type': 'application/json',
        'Authorization': "Bearer #{token.auth_token}"
      }

      ids.map do |id|
        query_hash[:id] = id
        response = request_get(url, query_hash, header)
        record = JSON.parse response.body
        raise RuntimeError.new(record.to_json.to_s) unless record['success']

        if block_given?
          yield record
        else
          record['result']
        end
      end
    end

    # == list 에서 모든 데이터를 요청합니다.
    def request_lists(url, body, header)
      body[:token] = ''
      data = []
      while body[:token].nil? == false
        response = request_post(url, body, header)
        each_data = JSON.parse(response.body) 
        raise RuntimeError.new(each_data.to_json.to_s) unless each_data['success']

        body[:token] = each_data['result']['next_token']
        data << if block_given?
                  yield each_data
                else
                  each_data
                end
      end
      data.flatten
    end

    ### === 데이터를 정제하는 로직입니다.

    ## === product 데이터를 정제합니다.

    def form_variants(product)
      variants = product['variants']

      # variants 가 빈배열인 데이터가 있다.
      # 이 경우, default 옵션 데이터를 만들어 줄 필요가 있다.
      if variants.empty?
        return [
          {
            id: product['sku'],
            name: 'default',
            price: product['price']
          }
        ]
      end

      variants.map do |variant|
        {
          id: "#{product['sku']}-#{variant['variant_sku']}",
          name: variant['variant_sku'],
          price: variant['variant_price']
        }
      end
    end

    ## === order 데이를 정제합니다.

    def cancelled_status(order_status)
      map_order_status(order_status) if order_status == 13
    end

    def shipping_status(order_status)
      map_order_status(order_status) if [6, 7, 8].include? order_status
    end

    # == 센도의 결제 방법(숫자) 글자로 바꿔주는 함수입니다.
    # == TODO: 주문 상태 리펙토링 후 아래 로직을 수정해야 합니다.
    # == 우리의 판매 방법의 수가 센도의 판매 방법의 수 보다 같거나 많을 것이라고 판단하여 아래와 같이 case 구문으로 구현하였습니다.
    def map_pay_method(sendo_pay_method)
      pay_methods = [0, 'COD', 'Senpay', 3, 'Combine', 'PayLater'].freeze
      pay_methods[sendo_pay_method]
    end

    # == 센도의 주문상태(숫)를 글자로 바꿔주는 함수입니다.
    # == TODO: 주문 상태 리펙토링 후 아래 로직을 수정해야 합니다.
    # == 우리의 주문 상태가 센도의 주문 상태보다 수가 적을 것이라고 판단하여 아래와 같이 array로 구현하였습니다.
    def map_order_status(sendo_order_status)
      allowed_order_status = {
        'New': [2],
        'Proccessing': [3],
        'Shipping': [6],
        'POD': [7],
        'Completed': [8],
        'Closed': [10],
        'Delaying': [11],
        'Delay': [12],
        'Cancelled': [13],
        'Splitting': [14],
        'Splitted': [15],
        'Merging': [19],
        'Returning': [21],
        'Returned': [22],
        'WaitingSendo': [23]
      }
      order_status = allowed_order_status.select { |_key, value| value.include?(sendo_order_status) }
      if order_status.empty?
        nil
      else
        order_status.keys[0].to_s
      end
    end

    def paid_at(sales_data)
      if sales_data['order_status'] == 8
        Time.at(sales_data['order_date_time_stamp']).getutc 
      else
        nil
      end
    end
  end
end
