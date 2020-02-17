module Gomisa
  module ProductItemGroupService
    class ItemUpdateService
      attr_reader :params
      attr_reader :product_item

      def initialize(product_item, params)
        @product_item = product_item
        @item_params = params
      end

      def call
        return @product_item.update(@item_params) if @item_params[:active].nil?
        return @product_item.update(@item_params) if !@product_item.active && @product_item.activable?
        false
      end
    end
  end
end
