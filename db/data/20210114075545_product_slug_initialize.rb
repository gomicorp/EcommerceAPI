class ProductSlugInitialize < ActiveRecord::Migration[6.0]

  def recursive_try_slug(product, title, count = 1)
    return if count > 100
    duplicated_product = Product.global.find(title) rescue nil
    translated_title = translated_title.presence || product.id.to_s
    
    product.slug = duplicated_product ? "#{translated_title}-#{product.slug_sequence}" : title
    puts "Try#{count} : #{product.slug}"
    product.save
  rescue StandardError, Mysql2::Error, ActiveRecord::RecordNotUnique => e
    recursive_try_slug(product, product.slug, count + 1)
  end

  def up
    ApplicationRecord.country_context_with 'global' do
      Product.global.each do |product|
        title = product.translated_title.presence || product.id.to_s
        recursive_try_slug(product, title, 1)
      end

      Product.global.each do |product|
        product.slug = nil #title.parameterize.presence || product.id
        product.save # bomb
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
