# == Schema Information
#
# Table name: interest_tags
#
#  id         :bigint           not null, primary key
#  name       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class InterestTag < ApplicationRecord
end
