module Memberships
  class DefaultDecorator < MembershipDecorator
    data_keys_from_model :membership
  end
end
