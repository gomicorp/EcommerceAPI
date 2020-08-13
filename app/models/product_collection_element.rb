# == Schema Information
#
# Table name: product_collection_elements
#
#  id                    :bigint           not null, primary key
#  amount                :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  product_collection_id :bigint           not null
#  product_item_id       :bigint           not null
#
# Indexes
#
#  index_product_collection_elements_on_product_collection_id  (product_collection_id)
#  index_product_collection_elements_on_product_item_id        (product_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_collection_id => product_collections.id)
#  fk_rails_...  (product_item_id => product_items.id)
#
class ProductCollectionElement < ApplicationRecord
  belongs_to :product_item
  belongs_to :collection, class_name: 'ProductCollection', foreign_key: :product_collection_id

  after_create :after_save_propagation
  after_destroy :after_save_propagation

  private

  def after_save_propagation
    col = collection
    col.calculate_price_columns
    col.save
  end
end
