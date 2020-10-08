# == Schema Information
#
# Table name: seo_tag_sets
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  page_type  :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SeoTagSet < ApplicationRecord
  has_many :tags, class_name: 'SeoTag'
  accepts_nested_attributes_for :tags, allow_destroy: true
  PAGE_TYPES = %w[product main global].freeze

  validates_inclusion_of :page_type, in: PAGE_TYPES

  def self.available_page_types
    PAGE_TYPES
  end

end
