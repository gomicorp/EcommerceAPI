class ProductItemGroup < NationRecord
  belongs_to :brand
  has_many :items, class_name: 'ProductItem', foreign_key: :item_group_id, dependent: :destroy

  has_many :product_attribute_product_item_groups, dependent: :destroy
  has_many :product_attributes, through: :product_attribute_product_item_groups

  has_one :zohomap, as: :zohoable

  validates_presence_of :name
end
