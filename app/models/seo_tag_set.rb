# == Schema Information
#
# Table name: seo_tag_sets
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SeoTagSet < ApplicationRecord
  has_many :tags, class_name: "SeoTag"
  accepts_nested_attributes_for :tags, allow_destroy: true
end
