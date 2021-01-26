module Companies
  class WithBrandCountryDecorator < DefaultDecorator
    data_keys_from_model :company
    data_key :brands, with: Brands::DefaultDecorator
    data_key :countries

    def countries
      Countries::DefaultDecorator.decorate(super)
    end
  end
end
