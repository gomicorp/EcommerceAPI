# == Schema Information
#
# Table name: user_interest_tags
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  interest_tag_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_user_interest_tags_on_interest_tag_id  (interest_tag_id)
#  index_user_interest_tags_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (interest_tag_id => interest_tags.id)
#  fk_rails_...  (user_id => users.id)
#
class UserInterestTag < ApplicationRecord
  belongs_to :interest_tag
end
