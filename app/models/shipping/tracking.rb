module Shipping
  class Tracking < ShippingModel
    def self.all
      adapter.get_trackings.map { |data| new data }
    end

    # 첫 번째 인자에 id 를 줘도 됩니다.
    def self.find(tracking_number, carrier_code = nil)
      new adapter.get_tracking(tracking_number, carrier_code)
    end

    # 첫 번째 인자에 id 를 줘도 됩니다.
    def self.create(tracking_number, carrier_code = nil)
      new adapter.create_tracking(tracking_number, carrier_code)
    end

    def delete
      klass = self.class
      klass.new klass.adapter.delete_tracking(id)
    end

    # 첫 번째 인자에 id 를 줘도 됩니다.
    def self.delete(tracking_number, carrier_code = nil)
      new adapter.delete_tracking(tracking_number, carrier_code)
    end

    def update(**attributes)
      klass = self.class
      klass.new klass.adapter.update_tracking(id, **attributes)
    end

    # 첫 번째 인자에 id 를 줘도 됩니다.
    def self.update(tracking_number, carrier_code = nil, **attributes)
      new adapter.update_tracking(tracking_number, carrier_code, **attributes)
    end

    private

    def self.adapter
      @adapter ||= ParcelTrackingAdapter::AftershipAdapter.new
    end
  end
end
