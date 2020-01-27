module Haravan
  class Brand < Api::Record
    self.schema = %i[name _items]

    def self.http_auth
      {

      }
    end

    def variants
      @variants ||= _items.group_by(&:variant_id).map { |variant_id, variant_items| Variant.new(id: variant_id, items: variant_items) }
    end

    def total
      @total ||= Vo::Total.new(_items)
    end

    def rowspan
      @rowspan ||= variants.map(&:prices).flatten.count + 1
    end
  end
end
