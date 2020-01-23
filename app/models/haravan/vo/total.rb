module Haravan
  module Vo
    class Total
      attr_reader :price, :quantity, :orders

      def initialize(items)
        @price = 0
        @quantity = 0
        @orders = []
        reduce_items(items)
      end


      private

      def reduce_items(items)
        items.each do |item|
          @price += item.price * item.quantity
          @quantity += item.quantity
          @orders << item.order
        end
      end
    end
  end
end