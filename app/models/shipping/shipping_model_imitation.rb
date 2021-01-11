module Shipping
  class ShippingModelImitation < ActiveRecord::Imitation

    # def self.all
    #   after_ship = ParcelTrackingAdapter::AftershipAdapter.new
    #   Collection.new(after_ship, entry_class: self).all
    # end
    #
    # def self.find(primary_key)
    #   after_ship = ParcelTrackingAdapter::AftershipAdapter.new
    #
    # end

    # def self.create(attribute = {})
    #   new(attribute).save
    # end


    # 아직 안쓰입니다.
    #
    # class Collection
    #   include UseAdapter::Collection
    #   attr_reader :recent_response
    #   attr_reader :entry_class
    #
    #   attr_reader :entries
    #
    #   def initialize(adapter, entry_class:)
    #     @adapter = adapter
    #     @base_url = adapter.class::BASE_URL
    #     @recent_response = nil
    #     @entry_class = entry_class
    #     p entry_class
    #
    #     @entries = []
    #   end
    #
    #   def response
    #     @recent_response
    #   end
    #
    #   def endpoints
    #     entry_class::ENDPOINTS
    #   end
    #
    #   # return Array<@entries, Courier>
    #   def all
    #     url = base_url + endpoints.dig(:all, :path)
    #     @recent_response = Faraday.get(url, nil, adapter.default_header)
    #
    #     begin
    #       res = JSON.parse @recent_response.body
    #
    #       if adapter.is_serious_error? res.dig('meta', 'code')
    #         raise 'an error occurred! : ' + res.dig('meta', 'message')
    #       end
    #
    #       @entries = res.dig('data', endpoints.dig(:all, :entries)).map { |data| entry_class.new(data) }
    #     rescue JSON::ParserError => _e
    #       nil
    #     ensure
    #       @entries
    #     end
    #   end
    #
    #   # def find(id, *args)
    #   #   # url = BASE_URL + '/trackings/' + carrier_code + '/' + tracking_number
    #   #   # response = Faraday.get(url, nil, default_header)
    #   #   #
    #   #   # begin
    #   #   #   data = JSON.parse response.body
    #   #   #
    #   #   #   if is_serious_error? data['meta']['code']
    #   #   #     raise 'an error occurred! : ' + data['meta']['message']
    #   #   #   end
    #   #   #
    #   #   #   res_result = data['data']['tracking']
    #   #   #   if res_result
    #   #   #     checkpoints = res_result['checkpoints'].map { |checkpoint| checkpoint.select { |k| %w[checkpoint_time message].include? k } }
    #   #   #     Result.new(tracking_number, carrier_code, res_result['active'], res_result['tag'], res_result['subtag_message'], res_result['created_at'], checkpoints)
    #   #   #   end
    #   #   # rescue JSON::ParserError => e
    #   #   #   nil
    #   #   # end
    #   # end
    # end
  end
end
