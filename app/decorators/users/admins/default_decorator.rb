module Users
  module Admins
    class DefaultDecorator < UserDecorator
      data_keys_from_model :admin
    end
  end
end
