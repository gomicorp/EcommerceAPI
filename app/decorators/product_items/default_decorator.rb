module ProductItems
  class DefaultDecorator < ProductItemDecorator
    delegate_all

    data_keys_from_model :product_item
  end
end
