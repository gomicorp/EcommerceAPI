class ProductItemProductOption < ApplicationRecord
  belongs_to :item, class_name: 'ProductItem', foreign_key: :product_item_id
  belongs_to :option, class_name: 'ProductOption', foreign_key: :product_option_id
end
