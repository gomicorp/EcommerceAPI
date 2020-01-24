module Haravan
  module Vo
    class Terms
      def initialize(start_at, end_at)
        if start_at
          @start_at = start_at.in_time_zone('UTC').strftime('%F %H:%M') rescue self.start_at
        end

        if end_at
          @end_at = end_at.in_time_zone('UTC').strftime('%F %H:%M') rescue self.end_at
        end
      end

      def start_at
        @start_at ||= Time.now.in_time_zone('UTC').beginning_of_day.strftime('%F %H:%M')
      end

      def start_at=(datetime)
        @start_at = datetime.in_time_zone('UTC').strftime('%F %H:%M') || start_at
      end

      def end_at
        @end_at ||= Time.now.in_time_zone('UTC').end_of_day.strftime('%F %H:%M')
      end

      def end_at=(datetime)
        @end_at = datetime.in_time_zone('UTC').strftime('%F %H:%M') || end_at
      end
    end
  end
end
