module Common
  class CategoriesController < BaseController

    def index
      @categories = Category.all
    end
  end
end
