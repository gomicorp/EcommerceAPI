module Haravan
  module Vo
    class Terms
      def initialize(start_time, end_time)
        self.start_at = start_time if start_time
        self.end_at = end_time if end_time
      end

      def range
        start_time..end_time
      end

      #
      # Start at
      #

      def start_time
        @start_time ||= Time.now.in_time_zone('UTC').beginning_of_day
      end

      def start_time=(datetime)
        @start_time = datetime.in_time_zone('UTC').beginning_of_day
      end

      def start_at
        @start_at ||= start_time.strftime('%F %H:%M')
      end

      def start_at=(datetime)
        self.start_time = datetime
        @start_at = start_time.strftime('%F %H:%M') || start_at
      end


      #
      # End at
      #

      def end_time
        @end_time ||= Time.now.in_time_zone('UTC').end_of_day
      end

      def end_time=(datetime)
        time = datetime.in_time_zone('UTC') rescue Time.now.in_time_zone('UTC')
        @end_time = time.end_of_day
      end

      def end_at
        @end_at ||= end_time.strftime('%F %H:%M')
      end

      def end_at=(datetime)
        self.end_time = datetime
        @end_at = end_time.strftime('%F %H:%M')
      end
    end
  end
end
