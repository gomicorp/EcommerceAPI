class ShippingAddress < ApplicationRecord
  has_one :user_addresses, class_name: 'UserShippingAddress', dependent: :destroy
  has_one :orderer, class_name: 'User', foreign_key: :default_address_id, dependent: :nullify
  has_one :user, through: :user_addresses
end
