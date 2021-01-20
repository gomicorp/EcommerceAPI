module Companies
  class WithBrandCountryDecorator < DefaultDecorator
    data_keys_from_model :company
    data_key :brands, with: Brands::DefaultDecorator
    data_key :countries, with: Countries::DefaultDecorator
  end
end
