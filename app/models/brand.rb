# == Schema Information
#
# Table name: brands
#
#  id          :bigint           not null, primary key
#  description :text(65535)
#  name        :string(255)
#  slogan      :string(255)
#  subtitle    :string(255)
#  theme_color :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  company_id  :bigint
#  country_id  :bigint
#  pixel_id    :bigint
#
# Indexes
#
#  index_brands_on_company_id  (company_id)
#  index_brands_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (company_id => companies.id)
#  fk_rails_...  (country_id => countries.id)
#
class Brand < NationRecord
  include Translatable
  include Approvable
  extend_has_one_attached :logo
  extend_has_one_attached :first_image
  translate_column :name

  belongs_to :company
  has_many :products
  has_many :product_item_groups
  has_many :items, through: :product_item_groups, class_name: 'ProductItem'
  has_many :managers, through: :company

  # ===============================================
  has_many :product_option_brands, class_name: 'ProductOptionBrand', dependent: :delete_all
  has_many :product_options, through: :product_option_brands
  # ===============================================
  has_many :order_info_brands, class_name: 'OrderInfoBrand', dependent: :delete_all
  has_many :order_infos, through: :order_info_brands
  # ===============================================


  # ===============================================
  # 전시 전용 모델 관계
  has_many :side_menu_items, class_name: 'Store::SideMenuItem', as: :connectable
  # ===============================================


  def official_site_url
    '#'
  end

  def use_pixel?
    pixel_id.present?
  end

  # Company::ApproveRequest
  class ApproveRequest < ::ApproveRequest
    default_scope { where(approvable_type: :Brand) }
  end
end
