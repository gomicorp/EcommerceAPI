class ShippingAddress < ApplicationRecord
  has_one :user_addresses, class_name: 'UserShippingAddress', dependent: :destroy
  has_one :user, through: :user_addresses
end
