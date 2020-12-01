=begin








  DEPRECATED
  쓰.지.마.세.요.











































=end

module ParcelTrackingAdapter
  class TrackingmoreAdapter < BaseAdapter
    attr_reader :api_key

    Result = Struct.new(:tracking_number, :status)

    BASE_URL = 'https://api.trackingmore.com/v2/trackings/'
    REQUEST_LIMIT = 40

    def initialize
      @api_key = Rails.application.credentials.dig(Rails.env.to_sym, :trackingmore, :api_key)
    end

    def default_header
      # TODO: api_key는 테스트로 되어있기 때문에 수정해주세요.
      { "Content-Type":"application/json", "Trackingmore-Api-Key":api_key }
    end

    # serious의 기준 : 에러에 대해 알아야하는가, 몰라도 되는가.
    def is_serious_error?(status, error_code)
      return true unless [ 200, 201, 202 ].include? status

      # 4016 : Tracking already exists. 4017 : Tracking does not exist.
      acceptable_error_codes = [ 200, 201, 4016, 4017, 4031 ]
      return true unless acceptable_error_codes.include? error_code
      false
    end

    public

    # 송장 번호를 발급받았을 때 tracking을 생성해준다.
    def create_tracking(tracking_number, carrier_code)
      url = BASE_URL + "post"
      request_body = { "tracking_number": tracking_number, "carrier_code": carrier_code }
      response = Faraday.post(url, request_body.to_json, default_header)

      begin
        data = JSON.parse response.body

        if is_serious_error?(response.status, data["meta"]["code"])
          raise "an error occurred~ : " + data["meta"]["message"]
        end
      rescue JSON::ParserError => e
        nil
      end
    end

    # tracking_numbers : array
    def create_trackings(tracking_numbers, carrier_code)
      url = BASE_URL + "batch"

      tracking_numbers.each_slice(REQUEST_LIMIT) do |each_tracking_numbers|
        request_body = []
        each_tracking_numbers.each do |tracking_number|
          request_body.push({ "tracking_number": tracking_number, "carrier_code": carrier_code })
        end

        response = Faraday.post(url, request_body.to_json, default_header)

        begin
          data = JSON.parse response.body

          if is_serious_error?(response.status, data["meta"]["code"])
            raise "an error occurred~ : " + data["meta"]["message"]
          end
        rescue JSON::ParserError => e
          nil
        end
      end
    end

    # 해당 tracking의 상태를 가져온다.
    def get_tracking(tracking_number, carrier_code)
      url = BASE_URL + carrier_code + "/" + tracking_number
      response = Faraday.get(url, nil, default_header)

      begin
        data = JSON.parse response.body

        if is_serious_error?(response.status, data["meta"]["code"])
          raise "an error occurred~ : " + data["meta"]["message"]
        end

        # TODO: data['data']가 없는 경우 예외처리 해주세요.
        status = data['data']['status']
        Result.new(tracking_number, status)
      rescue JSON::ParserError => e
        nil
      end
    end

    # tracking_numbers : array
    def get_trackings(tracking_numbers)
      url = BASE_URL + "get?numbers=" + tracking_numbers.join(',')
      response = Faraday.get(url, nil, default_header)

      begin
        data = JSON.parse response.body

        if is_serious_error?(response.status, data["meta"]["code"])
          raise "an error occurred~ : " + data["meta"]["message"]
        end

        if data['data'].length > 0
          data['data']['items'].map {|item| Result.new(item['tracking_number'], item['status'])}
        end
      rescue JSON::ParserError => e
        nil
      end
    end

    # 배송이 완료되었을 때 tracking을 지워준다.
    def delete_tracking(tracking_number, carrier_code)
      url = BASE_URL + carrier_code + "/" + tracking_number
      response = Faraday.delete(url, nil, default_header)

      begin
        data = JSON.parse response.body

        if is_serious_error?(response.status, data["meta"]["code"])
          raise "an error occurred~ : " + data["meta"]["message"]
        end
      rescue JSON::ParserError => e
        nil
      end
    end

    # tracking_numbers : array
    def delete_trackings(tracking_numbers, carrier_code)
      url = BASE_URL + "delete"

      tracking_numbers.each_slice(REQUEST_LIMIT) do |each_tracking_numbers|
        request_body = []
        each_tracking_numbers.each do |tracking_number|
          request_body.push({ "tracking_number": tracking_number, "carrier_code": carrier_code })
        end

        response = Faraday.post(url, request_body.to_json, default_header)

        begin
          data = JSON.parse response.body

          if is_serious_error?(response.status, data["meta"]["code"])
            raise "an error occurred~ : " + data["meta"]["message"]
          end
        rescue JSON::ParserError => e
          nil
        end
      end
    end
  end
end
