module Companies
  class WithBrandCountryDecorator < DefaultDecorator
    data_keys_from_model :company
    data_keys :brands, :countries

    def countries
      object.brands.map{|brand| brand.country}.uniq
    end
  end
end
