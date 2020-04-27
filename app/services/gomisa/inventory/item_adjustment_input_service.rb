module Gomisa
  module Inventory
    class ItemAdjustmentInputService
      attr_reader :item, :adjustment

      def initialize(item, adjustment)
        @item = item
        @adjustment = adjustment
      end

      def call
        ActiveRecord::Base.transaction do
          item.adjustments << adjustment

          adjustment.amount.times do
            item.barcodes.create!
          end

          adjustment.result_quantity = item.barcodes_count
          adjustment.save!
        end
      end
    end
  end
end
