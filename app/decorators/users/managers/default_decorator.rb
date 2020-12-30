module Users
  module Managers
    class DefaultDecorator < UserDecorator
      delegate_all

      data_keys_from_model :manager
    end
  end
end
