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
