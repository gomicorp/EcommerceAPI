# == Schema Information
#
# Table name: interest_tags
#
#  id         :bigint           not null, primary key
#  name       :text(4294967295)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class InterestTag < NationRecord
end
