module Gomisa
  class ProductItemIndexService
    attr_reader :product_items

    def initialize(from, to, channel, query)
      @from = from
      @to = to
      @channel = channel
      @query = query
    end

    def search
      search_service = Gomisa::ProductItemSearchService.new(ProductItem, @query)
      search_service.call
      @product_items = search_service.collection
    end

    def aggregater(collection)
      product_items = []

      collection.all.map{ |k, v|
        attributes = k.attributes
        attributes[:stock] = k.stock
        attributes[:quantity] = k.exports_quantity(@from, @to, @channel)
        attributes[:brand] = k.item_group.brand
        product_items.push(attributes)
      }

      product_items
    end

    def call
      search
      @product_items = aggregater @product_items
    end
  end
end


