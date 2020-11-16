# == Schema Information
#
# Table name: interest_tags
#
#  id         :bigint           not null, primary key
#  created_by :string(255)
#  name       :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  country_id :bigint
#
# Indexes
#
#  index_interest_tags_on_country_id  (country_id)
#
# Foreign Keys
#
#  fk_rails_...  (country_id => countries.id)
#
class InterestTag < NationRecord
end
