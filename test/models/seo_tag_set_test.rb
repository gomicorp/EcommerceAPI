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
require 'test_helper'

class SeoTagSetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
