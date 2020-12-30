module ProductOptions
  class DefaultDecorator < ProductOptionDecorator
    data_keys_from_model :product_option
  end
end
