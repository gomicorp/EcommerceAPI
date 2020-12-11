# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalChannel::ManagerFactory do
  before(:all) do
    @adapter = ExternalChannel::AdapterFactory.adapter('Haravan')
    @batch_type = 'product'
    @query = {
      'country_code': 'vn',
      'created': 'Mon, 30 Nov 2020 13:36:37 +0900',
      'updated': 'Mon, 30 Nov 2020 13:36:37 +0900'
    }
    @product_manager = ExternalChannel::Product::Manager.new(@adapter)
    @list = @adapter.get_list(@batch_type, @query)
  end

  it 'Validator.valid_all is true' do
    validator = @product_manager.validator.valid_all?(@list)
    # puts @list
    expect(validator).to eq(true)
  end

  it 'save_product' do
    ApplicationRecord.country_code = 'vn'
    data = {:id=>1025150741, :title=>"Son Dưỡng Môi Greyground Dual Lip Balm", :channel_name=>"Haravan", :brand_name=>"Greyground", :variants=>[{:id=>1056091702, :price=>253000, :name=>"Default Title"}]}
    result = @product_manager.saver.save_all(data)
    expect(result).to eq(true)
  end
=begin
  it 'save_all' do
    result = @product_manager.saver.save_product(@list)
    puts result
    expect result.should eq(true)
  end
=end
end