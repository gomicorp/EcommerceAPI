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
