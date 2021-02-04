module Gomisa
  module Inventory
    class ItemAdjustmentOutputService
      attr_reader :item, :adjustment

      def initialize(item, adjustment)
        @item = item
        @adjustment = adjustment
      end

      def call
        ActiveRecord::Base.transaction do
          item.adjustments << adjustment

          quantity = adjustment.amount.abs
          if item.alive_entities_count < adjustment.amount.abs
            quantity = item.alive_entities_count
          end
          item.entities.destroy(item.entities.alive.limit(quantity))

          adjustment.amount = quantity.abs * -1
          adjustment.result_quantity = item.entities_count
          adjustment.save!
        end
      end
    end
  end
end
