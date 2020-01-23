module Haravan
  class SettlementService
    attr_accessor :time_range, :time_filter, :orders
    attr_reader :items, :brands
    attr_reader :orders_all_count

    def initialize(time_range = nil)
      time_range = time_range || (Time.now.in_time_zone('UTC').yesterday.beginning_of_day..Time.now.in_time_zone('UTC').yesterday.end_of_day)
      @terms = Haravan::Vo::Terms.new(time_range.first, time_range.last)
    end

    def call
      fetch_orders_count
      fetch_orders
      @items = collect_items_of shipped_orders
      @brands = group_by_brand_for_items(@items).map { |name, items| Haravan::Brand.new(name: name, items: items) }
    end

    def shipped_orders
      @shipped_orders ||= orders.filter(&:delivered?)
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

    private

    def fetch_orders_count
      @orders_all_count = Haravan::Order.fetcher.fetch('orders/count.json', {
          created_at_min: @terms.start_at,
          created_at_max: @terms.end_at
      })[:count]
    end

    def fetch_orders
      @orders = Haravan::Order.search_by(
          fulfillment_status: 'shipped',
          created_at_min: @terms.start_at,
          created_at_max: @terms.end_at
      )
    end

    def group_by_brand_for_items(items)
      items.group_by(&:vendor)
    end
  end
end
