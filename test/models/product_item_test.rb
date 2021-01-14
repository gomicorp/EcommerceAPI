# == Schema Information
#
# Table name: product_items
#
#  id                         :bigint           not null, primary key
#  active                     :boolean          default(FALSE), not null
#  alive_barcodes_count       :integer          default(0), not null
#  barcodes_count             :integer          default(0), not null
#  cost_price                 :integer          default(0), not null
#  gomi_standard_product_code :string(255)      not null
#  name                       :string(255)
#  selling_price              :integer          default(0), not null
#  serial_number              :string(255)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  country_id                 :bigint
#  item_group_id              :bigint           not null
#
# Indexes
#
#  index_product_items_on_country_id                  (country_id)
#  index_product_items_on_gomi_standard_product_code  (gomi_standard_product_code) UNIQUE
#  index_product_items_on_item_group_id               (item_group_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (item_group_id => product_item_groups.id)
#
require 'test_helper'

class ProductItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
