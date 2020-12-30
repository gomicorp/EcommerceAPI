module ProductOptions
  class DefaultDecorator < ProductOptionDecorator
    delegate_all

    data_keys_from_model :product_option
  end
end
