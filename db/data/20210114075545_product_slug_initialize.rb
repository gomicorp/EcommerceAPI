class ProductSlugInitialize < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.country_context_with 'global' do
      Product.global.each do |product|
        locale = product.country.locale
        title = product.translate(locale: locale).title.presence || product.id
        product.slug ||= title
        product.save

        product.slug = title.parameterize.presence || product.id
        product.save # bomb
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
