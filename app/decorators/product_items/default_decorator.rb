module ProductItems
  class DefaultDecorator < ProductItemDecorator
    data_keys_from_model :product_item
  end
end
