module ProductCollections
  class DefaultDecorator < ProductCollectionDecorator
    delegate_all

    data_keys_from_model :product_collection
  end
end
