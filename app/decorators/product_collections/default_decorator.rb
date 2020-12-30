module ProductCollections
  class DefaultDecorator < ProductCollectionDecorator
    data_keys_from_model :product_collection
  end
end
