class SeoTagSet < ApplicationRecord
  has_many :tags, class_name: 'SeoTag'
  accepts_nested_attributes_for :tags, allow_destroy: true
  PAGE_TYPES = %w[product main global].freeze

  validates_inclusion_of :page_type, in: PAGE_TYPES

  def self.available_page_types
    PAGE_TYPES
  end

end
