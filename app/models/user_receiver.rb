class UserReceiver < ApplicationRecord
  belongs_to :user
  belongs_to :receiver, dependent: :destroy
end
