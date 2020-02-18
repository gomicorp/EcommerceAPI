module Gomisa
  module ProductItems
    class AdjustmentsController < ApiController
      before_action :set_product_item
      # before_action :set_adjustment, only: %i[show edit update destroy]

        def index
          @adjustments = @product_item.adjustments
        end

        def show
        end

        def create
          @adjustment = Adjustment.create(adjustment_params)

          if @adjustment.persisted?
            provider = @adjustment.amount.positive? ? Inventory::ItemAdjustmentInputService : Inventory::ItemAdjustmentOutputService
            @service = provider.new(@product_item, @adjustment)

            if @service.call
              render json: @product_item, template: "gomisa/product_item_groups/items/show"
            else
              render json: {}, status: :bad_request
            end
          end
        end

        def edit
        end

        def update
        end

        def destroy
        end

        protected

        def set_product_item
          @product_item = ProductItem.find(params[:product_item_id])
        end

        def set_adjustment
          @adjustment = @product_item.adjustments.find(params[:id])
        end

        def adjustment_params
          params.require(:adjustment).permit(:reason, :channel, :amount, :memo)
        end
      end
    end
  end
