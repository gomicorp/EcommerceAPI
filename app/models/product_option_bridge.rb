class ProductOptionBridge < ApplicationRecord
  belongs_to :connectable, polymorphic: true
  belongs_to :product_option

  def source_price
    connectable&.selling_price.to_i
  end

  def price
    source_price
    end
end
