module Users
  class DefaultDecorator < UserDecorator
    delegate_all

    data_keys_from_model :user
  end
end
