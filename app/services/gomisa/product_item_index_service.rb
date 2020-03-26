module Gomisa
  class ProductItemIndexService
    attr_reader :product_items

    def initialize(from, to, channel, query)
      @from = from
      @to = to
      @channel = channel
      @query = query
    end

    def call
      search
      @product_items = aggregator @product_items
    end

    private

    def search
      search_service = Gomisa::ProductItemSearchService.new(ProductItem, @query)
      search_service.call
      @product_items = search_service.collection
    end

    def aggregator(collection)
      product_items = []

      collection.all.map{ |k, v|
        attributes = k.attributes
        attributes[:exported_stock] = k.exports_quantity(@from, @to, @channel)
        attributes[:brand] = k.item_group.brand
        product_items.push(attributes)
      }

      product_items
    end
  end
end
