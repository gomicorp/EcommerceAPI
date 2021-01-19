module Companies
  class WithCountryDecorator < CompanyDecorator
    data_keys_from_model :company, except: %i[created_at updated_at]
    data_key :countries

    def countries
      object.brands.map{|brand| brand.country}.uniq
    end
  end
end
