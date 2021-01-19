module Companies
  class WithBrandCountryDecorator < DefaultDecorator
    data_keys_from_model :company
    data_keys :brands, :countries
  end
end
