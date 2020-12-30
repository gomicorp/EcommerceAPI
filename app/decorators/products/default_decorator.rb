module Products
  class DefaultDecorator < ApplicationDecorator
    delegate_all

    data_keys_from_model :product
  end
end
