# == Schema Information
#
# Table name: authentications
#
#  id         :bigint           not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_authentications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Authentication < ApplicationRecord
  belongs_to :user
end
