module Users
  module Managers
    class DefaultDecorator < UserDecorator
      data_keys_from_model :manager
    end
  end
end
