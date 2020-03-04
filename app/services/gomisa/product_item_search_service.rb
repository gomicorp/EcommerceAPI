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
      query.present?
    end

    def default
      collection.all
    end

    # ProductItem.where(name like query) 형태로 보이는데,
    # 메소드 이름의 목적과 다르지 않나요?
    def filter_by_brand_name_and_company_name
      @collection = collection.where("name LIKE ?", "%#{query}%")
    end
  end
end
