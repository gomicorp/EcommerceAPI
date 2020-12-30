module Companies
  class DefaultDecorator < CompanyDecorator
    delegate_all

    data_keys_from_model :company, except: %i[created_at updated_at]
  end
end
