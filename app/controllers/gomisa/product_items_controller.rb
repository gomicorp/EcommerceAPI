module Gomisa
  class ProductItemsController < BaseController
    # GET /gomisa/product_items.json
    def index
      @service = ProductItemIndexService.new(params[:from], params[:to], params[:channel], params[:query])
      @service.call
      @product_items = @service.product_items
      render json: @product_items
    end
  end
end
