# == Schema Information
#
# Table name: product_item_groups
#
#  id         :bigint           not null, primary key
#  deleted_at :datetime
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  brand_id   :bigint           not null
#  country_id :bigint
#
# Indexes
#
#  index_product_item_groups_on_brand_id    (brand_id)
#  index_product_item_groups_on_country_id  (country_id)
#  index_product_item_groups_on_deleted_at  (deleted_at)
#
# Foreign Keys
#
#  fk_rails_...  (brand_id => brands.id)
#  fk_rails_...  (country_id => countries.id)
#
class ProductItemGroup < NationRecord
  belongs_to :brand
  has_many :items, class_name: 'ProductItem', foreign_key: :item_group_id, dependent: :destroy
  # has_many :product_items, foreign_key: :item_group_id, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true

  has_many :product_attribute_product_item_groups, dependent: :destroy
  has_many :product_attributes, through: :product_attribute_product_item_groups

  has_one :zohomap, as: :zohoable

  validates_presence_of :name
end
