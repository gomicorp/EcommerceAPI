module Companies
  class WithBrandDecorator < DefaultDecorator
    delegate_all
    decorates_association :brands, with: BrandDecorator

    data_key :company
    data_key :brands
  end
end
