class ProductItemGroup < NationRecord
  acts_as_paranoid
  belongs_to :brand
  has_many :items, class_name: 'ProductItem', foreign_key: :item_group_id, dependent: :destroy
  # has_many :product_items, foreign_key: :item_group_id, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true

  has_many :product_attribute_product_item_groups, dependent: :destroy
  has_many :product_attributes, through: :product_attribute_product_item_groups

  has_one :zohomap, as: :zohoable

  validates_presence_of :name
end
