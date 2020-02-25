module Gomisa
  class ProductItemIndexService
    attr_reader :product_items

    def initialize(from, to, channel)
      @from = from
      @to = to
      @channel = channel
    end

    def aggregater
      product_items = []

      ProductItem.all.map{ |k, v|
        attributes = k.attributes
        attributes[:stock] = k.stock
        attributes[:quantity] = k.exports_quantity(@from, @to, @channel)
        attributes[:brand] = k.item_group.brand
        product_items.push(attributes)
      }

      product_items
    end

    def call
      @product_items = aggregater
    end
  end
end
