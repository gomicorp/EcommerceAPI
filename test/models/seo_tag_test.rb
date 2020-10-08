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
require 'test_helper'

class SeoTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
