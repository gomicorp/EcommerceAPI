module Common
  class CountriesController < BaseController

    def index
      @countries = Country.all
    end
  end
end
