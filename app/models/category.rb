# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  depth       :integer          default(1), not null
#  icon        :string(255)
#  is_active   :boolean          default(FALSE), not null
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  country_id  :bigint
#
# Indexes
#
#  index_categories_on_category_id  (category_id)
#  index_categories_on_country_id   (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (country_id => countries.id)
#
class Category < NationRecord
  belongs_to :category

  has_many :product_categories, class_name: 'ProductCategory'
  has_many :products, through: :product_categories


  # ===============================================
  # 전시 전용 모델 관계
  has_many :side_menu_items, class_name: 'Store::SideMenuItem', as: :connectable
  # ===============================================


  extend_has_one_attached :image

  validates_presence_of :name, :depth

end
