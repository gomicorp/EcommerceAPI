# == Schema Information
#
# Table name: seo_tags
#
#  id             :bigint           not null, primary key
#  tag_type       :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  seo_tag_set_id :bigint
#
# Indexes
#
#  index_seo_tags_on_seo_tag_set_id  (seo_tag_set_id)
#
# Foreign Keys
#
#  fk_rails_...  (seo_tag_set_id => seo_tag_sets.id)
#
class SeoTag < ApplicationRecord
  belongs_to :seo_tag_set
  has_many :tag_attributes, class_name: "SeoTagAttribute"
  accepts_nested_attributes_for :tag_attributes, allow_destroy: true

  validates_inclusion_of :tag_type, in: %w[link meta]
end
