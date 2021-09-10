class SeoTag < ApplicationRecord
  belongs_to :seo_tag_set
  has_many :tag_attributes, class_name: "SeoTagAttribute"
  accepts_nested_attributes_for :tag_attributes, allow_destroy: true

  validates_inclusion_of :tag_type, in: %w[link meta]
end
