module Haravan
  module Core
    module Timer
      def measure_duration(**opt)
        start_at = Time.now
        result = yield(opt)
        say_duration start_at, **opt
        result
      end

      def measure_duration_feed(message, millisecond = false, **opt)
        start_at = Time.now
        result = yield(opt)
        if millisecond
          args = get_duration_millisecond start_at, **opt
          message = message.gsub(':millisecond ', args[:millisecond])
        else
          args = get_duration_args start_at, **opt
          message = message.gsub(':duration ', args[:duration])
        end
        Rails.logger.debug message
        result
      end

      def say_duration(time_a, time_b = Time.now, **opt)
        args = get_duration_args(time_a, time_b, **opt)
        Rails.logger.debug "  (#{args.map { |k, v| [k.capitalize, v].join(': ') }.join(' | ')})".yellow
      end

      def get_duration_args(time_a, time_b = Time.now, **opt)
        diff = (time_b - time_a).to_i

        {
            duration: Time.at(diff).utc.strftime("%M:%S")
        }.merge(opt)
      end

      def get_duration_millisecond(time_a, time_b = Time.now, **opt)
        diff = ((time_b.to_f - time_a.to_f) * 1000).to_i

        {
            millisecond: diff.to_s
        }.merge(opt)
      end
    end
  end
end
