module Haravan
  module Api
    class Collection < Array
      attr_accessor :readable

      def self.build(arg)
        obj = new(arg)
        obj.readable = true
        obj
      end

      def filter
        self.class.build(super)
      end

      def inspect
        readable ? "#<#{self.class.name} length: #{length}, entry_type: \"#{first.class.name}\">" : super
      end
    end
  end
end
