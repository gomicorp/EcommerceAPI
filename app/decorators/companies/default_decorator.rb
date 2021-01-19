module Companies
  class DefaultDecorator < CompanyDecorator
    data_keys_from_model :company, except: %i[created_at updated_at]

    def brands
      Brand.unscoped.where(company_id: object.id)
    end

    def countries
      Brand.unscoped.where(company_id: object.id).map{|brand| brand.country}.uniq
    end
  end
end
