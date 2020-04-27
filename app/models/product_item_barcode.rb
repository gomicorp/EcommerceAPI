class ProductItemBarcode < ApplicationRecord
  has_not_paper_trail

  belongs_to :product_item, counter_cache: :barcodes_count
  # belongs_to :product_option_bridge
  # has_many :options, class_name: 'ProductOption', through: :product_option_bridge

  has_many :cart_item_barcodes
  has_many :cart_items, through: :cart_item_barcodes

  scope :alive, -> { where(expired_at: nil) }

  after_save :update_counter_cache
  after_destroy :update_counter_cache

  def expire!
    update_attribute(:expired_at, DateTime.now)
  end

  def disexpire!
    update_attribute(:expired_at, nil)
  end

  private

  def update_counter_cache
    product_item.send(:update_counter_cache)
  end
end
