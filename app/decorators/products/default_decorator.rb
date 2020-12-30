module Products
  class DefaultDecorator < ProductDecorator
    delegate_all

    data_keys_from_model :product
  end
end
