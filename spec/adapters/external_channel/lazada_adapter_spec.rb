
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalChannel::LazadaAdapter do
  before(:all) do
    @adapter = ExternalChannel::AdapterFactory.adapter('lazada')
    @query = {
      'country_code': 'vn',
      'created': 'Mon, 30 Nov 2020 13:36:37 +0900',
      'updated': 'Mon, 30 Nov 2020 13:36:37 +0900'
    }
  end

  context 'products' do
    before do
      @parse_query_hash = @adapter.parse_query_hash(ExternalChannel::LazadaAdapter::QUERY_MAPPER['products'], @query)
      puts '# parse_query_hash'
      puts @parse_query_hash
      puts
    end

    context 'call_products' do
      before do
        puts '# call_products'
        @call_products = @adapter.call_products(@parse_query_hash)
        # puts @call_products.to_json
        puts
      end

      it 'refine_products' do
        puts '# refine_products'
        refine_products = @adapter.refine_products(@call_products)
        # puts refine_products
        puts
        expect { @adapter }.not_to raise_error
      end
    end
  end

  context 'orders' do
    before do
      @parse_query_hash = @adapter.parse_query_hash(ExternalChannel::LazadaAdapter::QUERY_MAPPER['orders'], @query)
      puts '# parse_query_hash'
      puts @parse_query_hash
      puts
    end

    context 'call_orders' do
      before do
        puts '# call_orders'
        @call_orders = @adapter.call_orders(@parse_query_hash)
        # puts @call_orders.to_json
        puts
      end

      it 'refine_orders' do
        puts '# refine_orders'
        refine_orders = @adapter.refine_orders(@call_orders)
        # puts refine_orders
        puts
        expect { @adapter }.not_to raise_error
      end
    end
  end
end
