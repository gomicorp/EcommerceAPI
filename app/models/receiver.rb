class Receiver < ApplicationRecord
  has_one :user_receiver, dependent: :destroy
  has_one :user, through: :user_receiver
end
