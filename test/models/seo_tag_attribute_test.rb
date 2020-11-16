# == Schema Information
#
# Table name: seo_tag_attributes
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  seo_tag_id :bigint
#
# Indexes
#
#  index_seo_tag_attributes_on_seo_tag_id  (seo_tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (seo_tag_id => seo_tags.id)
#
require 'test_helper'

class SeoTagAttributeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
