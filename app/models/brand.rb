class Brand < ApplicationRecord
  include Translatable
  extend_has_one_attached :logo
  translate_column :name

  belongs_to :company
  belongs_to :country
  has_many :products

  def official_site_url
    '#'
  end

  def use_pixel?
    pixel_id.present?
  end
end
