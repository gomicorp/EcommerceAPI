module Haravan
  class SettlementService
    attr_accessor :time_range, :time_filter, :orders
    attr_reader :items, :brands

    def initialize(time_range = nil)
      @time_range = time_range || (Time.now.in_time_zone('UTC').yesterday.beginning_of_day..Time.now.in_time_zone('UTC').yesterday.end_of_day)

      @orders = Haravan::Order.search_by(
          fulfillment_status: 'shipped',
          created_at_min: "#{@time_range.first&.strftime('%F')} 00:00",
          created_at_max: "#{@time_range.last&.strftime('%F')} 00:00"
      )
      @brands = {}
    end

    def call
      @items = collect_items_of orders
      @brands = group_by_brand_for_items @items
      arrange_items
    end

    def shipped_orders
      @shipped_orders ||= orders.filter(&:shipped?)
    end

    def collect_items_of(orders)
      item_list = []
      orders.each do |order|
        order.items.each do |item|
          item_list << item.merge(order: {id: order.id, name: order.name})
        end
      end
      item_list
    end

    def arrange_items
      @brands.each do |brand_name, brand_items|
        @brands[brand_name] = {}
        grouped_by_variant_identity = items_group_by_variant_id(brand_items)
        grouped_by_variant_identity.each do |variant_id, variant_items|
          @brands[brand_name][variant_id] ||= {}

          variant_items.group_by { |item| item[:price] }.each do |variant_price, variant_items|
            @brands[brand_name][variant_id][variant_price] = {
                items: variant_items,
                total: reduce_items(variant_items)
            }
          end
        end
        @brands[brand_name][:total] = reduce_items(brand_items)
      end
    end

    private

    def group_by_brand_for_items(items)
      items.group_by { |item| item[:vendor] }
    end

    def items_group_by_variant_id(items)
      items.group_by { |item| item[:variant_id] }
    end

    def reduce_items(items)
      total = {
          ordered_price: 0,
          quantity: 0,
          orders: []
      }
      items.each do |item|
        total[:ordered_price] += item[:price] * item[:quantity]
        total[:quantity] += item[:quantity]
        total[:orders] << item[:order]
      end

      total
    end
  end
end
