module Companies
  class WithCountryDecorator < DefaultDecorator
    data_keys_from_model :company, except: %i[created_at updated_at]
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
