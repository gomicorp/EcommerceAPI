class ProductSlugInitialize < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.country_context_with 'global' do
      Product.global.find_each(&:save)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
