module Companies
  class DefaultDecorator < CompanyDecorator
    data_keys_from_model :company, except: %i[created_at updated_at]

    def brands
      object.brands
    end

    def countries
      brands.map{|brand| brand.country}.uniq
    end
  end
end
