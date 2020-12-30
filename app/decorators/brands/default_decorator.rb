module Brands
  class DefaultDecorator < ApplicationDecorator
    delegate_all

    data_keys_from_model :brand
    data_key :name do |record|
      record.translate.name
    end
  end
end
