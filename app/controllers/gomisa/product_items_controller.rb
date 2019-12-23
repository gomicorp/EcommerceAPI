module Gomisa
  class ProductItemsController < BaseController
    # GET /gomisa/product_items.json
    def index
      @items = ProductItem.all
    end
  end
end
