module Haravan
  class SettlementService
    include Core::Timer
    attr_accessor :terms, :orders
    attr_reader :params, :items, :brands

    def initialize(terms, params)
      @terms = terms
      @params = params
    end

    def call
      measure_duration do |opt|
        case params.dig(:search, :method)
        when 'financial_status'
          paid_orders
        when 'fulfillment_status'
          shipped_orders
        else
          shipped_orders
        end

        @items = collect_items_of @orders
        opt[:collection] = orders.count
        @brands = group_by_brand_for_items(@items)
                      .map { |name, items|
                        next if brand_name && brand_name != name
                        Haravan::Brand.new(name: name, items: items)
                      }
                      .compact
      end
    end

    def shipped_orders
      @orders ||= Haravan::Order.search_by(
          fulfillment_status: 'shipped',
          created_at_min: @terms.start_at,
          created_at_max: @terms.end_at,
          brand_name: brand_name
      ).filter(&:delivered?)
    end

    def paid_orders
      @orders ||= Haravan::Order.search_by(
          financial_status: 'paid',
          created_at_min: @terms.start_at,
          created_at_max: @terms.end_at,
          brand_name: brand_name
      ).filter do |order|
        order.transactions
            .filter { |t| t.kind == 'capture' && t.created_at.in?(@terms.range) }
            .first
      end
    end

    private

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

    def group_by_brand_for_items(items)
      items.group_by(&:vendor)
    end

    def brand_name
      params[:id].presence
    end
  end
end
