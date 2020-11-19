module ParcelTrackingAdapter
  class AftershipAdapter < BaseAdapter
    attr_reader :api_key
    # attr_reader :couriers

    Result = Struct.new(:tracking_number, :carrier_code, :active, :status, :status_message, :created_at, :checkpoints)

    BASE_URL = 'https://api.aftership.com/v4'
    REQUEST_LIMIT = 40

    def initialize
      @api_key = Rails.application.credentials.dig(:aftership, :api_key)
    end

    def default_header
      { "Content-Type": 'application/json', "aftership-api-key": api_key }
    end

    # serious의 기준 : 에러에 대해 알아야하는가, 몰라도 되는가.
    def is_serious_error?(error_code)
      # 특별히 허용하는 코드들
      return false if error_code.in?([ 4003, 4004 ])

      # 일반적인 에러는 뱉는다.
      return true if error_code.to_s.start_with?('4') || error_code.to_s.start_with?('5')

      # 나머지는 괜찮은 응답 코드.
      false
    end

    def couriers
      @couriers ||= Courier.all
    end

    def trackings
      @trackings ||= Tracking.all
    end


    # activate된 배송사 리스트를 가져온다.
    def get_couriers
      url = BASE_URL + "/couriers"
      response = Faraday.get(url, nil, default_header)

      begin
        JSON.parse response.body
      rescue JSON::ParserError => e
        nil
      end
    end


    # 송장 번호를 발급받았을 때 tracking을 생성해준다.
    def create_tracking(tracking_number, carrier_code)
      url = BASE_URL + '/trackings'

      query = { slug: carrier_code, tracking_number: tracking_number, language: 'th' }
      request_body = { tracking: query }
      response = Faraday.post(url, request_body.to_json, default_header)

      safe_data_with response do |data|
        data['tracking']
      end
    end

    # 해당 tracking의 상태를 가져온다.
    #
    def get_tracking(tracking_number, carrier_code = nil)
      parameter = build_parameter(tracking_number, carrier_code)
      url = BASE_URL + '/trackings/' + parameter

      response = Faraday.get(url, nil, default_header)

      safe_data_with response do |data|
        # ap response.body
        data['tracking']
      end
    end

    # tracking_numbers : array
    # GET /trackings API call has max 1,000,000 return results limit.
    # page : Page to show. (Default: 1)
    # limit : Number of trackings each page contain. (Default: 100, Max: 200)
    def get_trackings
      url = BASE_URL + '/trackings'

      response = Faraday.get(url, nil, default_header)

      safe_data_with response do |data|
        data['trackings']
      end
    end

    # 배송이 완료되었을 때 tracking을 지워준다.
    def delete_tracking(tracking_number, carrier_code = nil)
      parameter = build_parameter(tracking_number, carrier_code)
      url = BASE_URL + '/trackings/' + parameter

      response = Faraday.delete(url, nil, default_header)

      safe_data_with response do |data|
        data['tracking']
      end
    end

    # 배송이 완료되었을 때 tracking을 지워준다.
    def update_tracking(tracking_number, carrier_code = nil, **query)
      parameter = build_parameter(tracking_number, carrier_code)
      url = BASE_URL + '/trackings/' + parameter

      query.reverse_merge!(slug: carrier_code, tracking_number: tracking_number, language: 'th')
      request_body = { tracking: query }
      response = Faraday.put(url, request_body.to_json, default_header)

      safe_data_with response do |data|
        data['tracking']
      end
    end


    private

    def check_error_code(code, message)
      if is_serious_error? code
        raise 'an error occurred! : ' + message
      end
    end

    def parse_response(response)
      body = (JSON.parse(response.body) rescue nil) || {}
      meta = body['meta'] || {}
      data = body['data'] || {}

      [meta, data]
    end

    def safe_data_with(response)
      meta, data = parse_response response
      check_error_code meta['code'], meta['message']

      yield(data) if block_given?
    end

    def build_parameter(id, tracking_number = nil)
      carrier_code, tracking_number = tracking_number, id if tracking_number

      if carrier_code
        [carrier_code, tracking_number].join('/')
      else
        id
      end
    end
  end
end
