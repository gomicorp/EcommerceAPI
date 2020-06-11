class SetProductOptionBrands < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.country_context_with 'global' do
      ProductOption.all.each do |option|
        option.bridges.each do |bridge|
          bridge.brands.each do |brand|
            ProductOptionBrand.create(product_option: option, brand: brand)
          end
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration if Rails.production?
  end
end
