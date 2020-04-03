class Receiver < ApplicationRecord
  has_one :user_receiver, dependent: :destroy
  has_one :orderer, class_name: 'User', foreign_key: :default_receiver_id, dependent: :nullify
  has_one :user, through: :user_receiver
end
