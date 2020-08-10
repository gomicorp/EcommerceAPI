module Sellers
  class ProductsController < BaseController
    before_action :set_product, only: %i[show]

    def index
      @products = running_products.ransack.result.paginate(page: params[:page], per_page: params[:per_page])
      # = index.json.jbuilder
    end

    def show
      # = show.json.jbuilder
    end

    def search
      @products = running_products.ransack(params[:query]).result.paginate(page: params[:page], per_page: params[:per_page])
    end

    def category
      @products = running_products.joins(:categories).ransack(params[:query]).result.paginate(page: params[:page], per_page: params[:per_page])
    end

    private

    def set_product
      @product = running_products.find(params[:id])
    end

    def running_products
      @running_products = Product.where(running_status: %w[running sold_out])
    end
  end
end
