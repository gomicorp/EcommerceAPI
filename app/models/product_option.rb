class ProductOption < ApplicationRecord
  belongs_to :option_group, class_name: ProductOptionGroup.name, dependent: :destroy, foreign_key: :product_option_group_id
  has_many :barcode_options
  has_many :barcodes, through: :barcode_options

  delegate :product, to: :option_group

  def title
    "#{option_group.name}: #{name}"
  end

  def price
    @price ||= product.price + additional_price
  end
end
