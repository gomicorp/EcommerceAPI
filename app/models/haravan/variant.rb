module Haravan
  class Variant < Api::Record
    self.schema = %i[id _items]

    def prices
      @prices ||= _items.group_by(&:price).map { |price, items| VariantPrice.new(price: price, items: items) }
    end
  end

  class VariantPrice < Api::Record
    self.schema = %i[price _items]

    def total
      @total ||= Vo::Total.new(_items)
    end

    def items
      _items
    end
  end
end
