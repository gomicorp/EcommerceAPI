module Users
  module Admins
    class DefaultDecorator < UserDecorator
      delegate_all

      data_keys_from_model :admin
    end
  end
end
