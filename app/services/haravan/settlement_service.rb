module Haravan
  class SettlementService
    attr_accessor :terms, :orders
    attr_reader :items, :brands

    def initialize(terms)
      @terms = terms
    end

    def call
      @items = collect_items_of shipped_orders
      @brands = group_by_brand_for_items(@items).map { |name, items| Haravan::Brand.new(name: name, items: items) }
    end

    def collect_items_of(orders)
      item_list = []
      orders.each do |order|
        order.items.each do |item|
          item.order = order.identity_object
          item_list << item
        end
      end
      item_list
    end

    def orders
      @orders ||= Haravan::Order.search_by(
          fulfillment_status: 'shipped',
          created_at_min: @terms.start_at,
          created_at_max: @terms.end_at
      )
    end

    def shipped_orders
      @shipped_orders ||= orders.filter(&:delivered?)
    end

    private

    def group_by_brand_for_items(items)
      items.group_by(&:vendor)
    end
  end
end
