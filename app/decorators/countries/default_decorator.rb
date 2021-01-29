module Countries
  class DefaultDecorator < CountryDecorator
    data_keys_from_model :country
  end
end
