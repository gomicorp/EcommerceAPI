class ProductItemBarcode < ApplicationRecord
  belongs_to :product_item, counter_cache: :barcodes_count
  # belongs_to :product_option_bridge
  # has_many :options, class_name: 'ProductOption', through: :product_option_bridge

  scope :alive, -> { where(cancelled_at: nil) }

  after_save :update_counter_cache
  after_destroy :update_counter_cache

  private

  def update_counter_cache
    product_item.send(:update_counter_cache)
  end
end
