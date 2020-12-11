# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalChannel::ManagerFactory do
  before(:all) do
    @adapter = ExternalChannel::AdapterFactory.adapter('Haravan')
    @batch_type = 'order'
    @query = {
      'country_code': 'vn',
      'created': 'Mon, 30 Nov 2020 13:36:37 +0900',
      'updated': 'Mon, 30 Nov 2020 13:36:37 +0900'
    }.to_h
    @order_manager = ExternalChannel::Order::Manager.new(@adapter)
    @list = @adapter.get_list(@batch_type, @query)
  end

  it 'Validator.valid_all is true' do
    validator = @order_manager.validator.valid_all?(@list)
    # puts @list
    expect(validator).to eq(true)
  end

  it 'save_order' do
    @order_manager.saver.save_all(@list)
    expect(true).to eq(true)
  end
end
