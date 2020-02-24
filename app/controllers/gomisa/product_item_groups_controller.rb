module Gomisa
  class ProductItemGroupsController < BaseController
    before_action :set_product_item_group, only: %i[show edit update destroy]

    def index
      @product_item_groups = ProductItemGroup.all
    end

    def create
      @service = ProductItemGroupService::Saver.new(params)
      @product_item_group = @service.product_item_group

      if @service.save
        render :show, status: :created
      else
        render json: {"error": "product_item_group not created"}, status: :bad_request
      end
    end

    def update
      @service = ProductItemGroupService::Saver.new(params)
      @product_item_group = @service.product_item_group

      if @service.save
        render :show, status: :reset_content
      else
        render json: {"error": "product_item_group not saved"}, status: :bad_request
      end
    end

    def destroy
      # delete will only delete current object record from db but not its associated children records from db.
      # destroy will delete current object record from db and also its associated children record from db.
      begin
        @product_item_group.delete
        render json: {}, status: :no_content
      rescue ActiveRecord::InvalidForeignKey => e
        render json: { error: e.to_s }, status: :failed_dependency
      end
    end

    private

    def product_item_group_params
      params.require(:product_item_group).permit(:name, :brand_id)
    end

    def product_item_bulk_params
      params.require(:product_item_group).permit(item: %i[name serial_number cost_price selling_price])
    end

    def set_product_item_group
      @product_item_group = ProductItemGroup.find(params[:id])
    end
  end
end
