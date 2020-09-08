# == Schema Information
#
# Table name: product_item_barcodes
#
#  id              :bigint           not null, primary key
#  expired_at      :datetime
#  leaved_at       :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  product_item_id :bigint           not null
#
# Indexes
#
#  index_product_item_barcodes_on_product_item_id  (product_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_item_id => product_items.id)
#
require 'test_helper'

class ProductItemBarcodeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
