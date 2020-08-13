# == Schema Information
#
# Table name: categories
#
#  id          :bigint           not null, primary key
#  depth       :integer          default(1), not null
#  icon        :string(255)
#  is_active   :boolean          default(FALSE), not null
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  country_id  :bigint
#
# Indexes
#
#  index_categories_on_category_id  (category_id)
#  index_categories_on_country_id   (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (country_id => countries.id)
#
require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
