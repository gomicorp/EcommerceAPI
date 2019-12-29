module Gomisa
  class ProductItemIndexService
    attr_reader :product_items
  
    def initialize(from, to, channel)
      @from = from
      @to = to
      @channel = channel
    end

    def filter_archived
      product_items = []
      
      ProductItem.all.map{ |k, v|
        if k.zohomap[:archived_at] == nil
          attributes = k.attributes
          attributes[:stock] = k.stock
          attributes[:quantity] = k.exports_quantity(@from, @to, @channel)
          attributes[:brand] = k.item_group.brand 
          product_items.push(attributes)
        end
      }

      product_items
    end

    def call
      @product_items = filter_archived
    end
  end
end
