class UserShippingAddress < ApplicationRecord
  belongs_to :user
  belongs_to :shipping_address
end
