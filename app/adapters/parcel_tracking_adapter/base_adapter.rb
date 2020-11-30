module ParcelTrackingAdapter
  class BaseAdapter
    attr_reader :tracker

    def initialize
      # stuff
      @tracker = Tracker.new
    end

    def default_header
      # stuff
    end

    public

    # 송장 번호를 발급받았을 때 tracking을 생성해준다.
    # def create_tracking(*tracking_numbers)
    #   tracker.create(*tracking_numbers)
    # end

    def create_tracking(tracking_number)
    end

    # # tracking_numbers : array
    # def create_trackings(tracking_numbers)
    # end

    # 해당 tracking의 상태를 가져온다.
    def get_tracking(tracking_number)
    end

    # tracking_numbers : array
    def get_trackings(tracking_numbers)
    end

    # 배송이 완료되었을 때 tracking을 지워준다.
    def delete_tracking(tracking_number)
    end
  end
end
