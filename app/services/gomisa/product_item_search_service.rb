module Gomisa
  class ProductItemSearchService
    attr_reader :collection
    attr_reader :query

    def initialize(collection, query)
      @collection = collection
      @query = query
    end

    def call
      check_query? ? filter_by_brand_name_and_company_name : default
    end

    private

    def check_query?
      query != "" && !query.nil?
    end

    def default
      collection.all
    end

    def filter_by_brand_name_and_company_name
      @collection = collection.where("name LIKE ?", "%#{query}%")
    end
  end
end
