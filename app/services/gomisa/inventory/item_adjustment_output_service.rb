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
          if item.alive_barcodes_count < adjustment.amount.abs
            quantity = item.alive_barcodes_count
          end
          item.barcodes.destroy(item.barcodes.alive.limit(quantity))

          adjustment.amount = quantity.abs * -1
          adjustment.result_quantity = item.barcodes_count
          adjustment.save!
        end
      end
    end
  end
end
