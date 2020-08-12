module Sellers
  class ProductsController < BaseController
    before_action :set_product, only: %i[show]

    def index
      @search = running_products.ransack
      @search.sorts = params[:sort] if params[:sort].present?
      @products = @search.result.paginate(page: params[:page], per_page: params[:per_page])
      # = index.json.jbuilder
    end

    def show
      # = show.json.jbuilder
    end

    def search
      @search = running_products.ransack(params[:query])
      @search.sorts = params[:sort] if params[:sort].present?
      @products = @search.result.paginate(page: params[:page], per_page: params[:per_page])
    end

    def category
      @search = running_products.includes(:categories).ransack(params[:query])
      @search.sorts = params[:sort] if params[:sort].present?
      @products = @search.result.paginate(page: params[:page], per_page: params[:per_page])
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
