module Gomisa
  class ProductItemsController < BaseController
      # GET /gomisa/brands
      # GET /gomisa/brands.json
    def index
      @items = ProductItem.all
    end
  end
end
