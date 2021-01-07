module Companies
  class DefaultDecorator < CompanyDecorator
    data_keys_from_model :company, except: %i[created_at updated_at]
  end
end
