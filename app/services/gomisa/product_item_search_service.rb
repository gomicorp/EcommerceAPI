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
      @collection = collection.includes(:brand, :company).where("companies.name LIKE ? OR brands.name LIKE ?", "%#{query}%", "%#{query}%").references(:brand, :company)
    end
  end
end
