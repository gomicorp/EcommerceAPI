module Products
  class DefaultDecorator < ProductDecorator
    data_keys_from_model :product
  end
end
