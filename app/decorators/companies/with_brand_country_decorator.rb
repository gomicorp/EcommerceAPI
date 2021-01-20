module Companies
  class WithBrandCountryDecorator < DefaultDecorator
    data_keys_from_model :company
    data_key :brands, with: Brands::DefaultDecorator
    data_key :countries

    def countries
      if super.count > 1
        Countries::DefaultDecorator.decorate_collection(super)
      else
        Countries::DefaultDecorator.decorate(super)
      end
    end
  end
end
