class Brand < NationRecord
  include Translatable
  include Approvable
  extend_has_one_attached :logo
  translate_column :name

  belongs_to :company
  has_many :products
  has_many :product_item_groups
  has_many :items, through: :product_item_groups, class_name: :ProductItem
  has_many :managers, through: :company

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
