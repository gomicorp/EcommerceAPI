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
            item.entities.create!
          end

          adjustment.result_quantity = item.entities_count
          adjustment.save!
        end
      end
    end
  end
end
