module Haravan
  module SettlementPhase
    def self.hello
      'world'
    end
    module_function :hello

    class Settlement
      attr_accessor :terms
      attr_accessor :brands
      attr_reader :orders

      def initialize(orders, terms = nil)
        @orders = orders
        @terms = terms if terms
      end

      private

      def remap_brands
        orders.group_by { |order| order[:vendor] }.each do |vendor, orders|
          {
              name: vendor,
              orders: orders
          }
        end
      end
    end
  end
end
