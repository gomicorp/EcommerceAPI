class ShippingAddress < ApplicationRecord
  has_many :user_addresses, class_name: 'UserShippingAddress', dependent: :destroy
  has_many :users, through: :user_addresses
end
