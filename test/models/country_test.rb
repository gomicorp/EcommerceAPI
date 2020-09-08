# == Schema Information
#
# Table name: countries
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  name_ko    :string(255)
#  locale     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  short_name :string(255)
#  iso_code   :string(255)
#
require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
