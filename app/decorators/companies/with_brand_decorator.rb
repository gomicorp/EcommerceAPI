module Companies
  class WithBrandDecorator < DefaultDecorator
    data_keys_from_model :company, except: %i[created_at updated_at]
    data_key :brands, with: Brands::DefaultDecorator
  end
end
