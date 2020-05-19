class SetCountriesDataToCart < ActiveRecord::Migration[6.0]
  def up
      default_country = Country.send(ENV['APP_COUNTRY'].to_sym)
      ap 'default_country is :'
      ap default_country
      pre_sale_statuses = %w[hand desk].freeze
      pre_sale_carts = Cart.unscoped.where(order_status: pre_sale_statuses)
      ordered_carts = Cart.unscoped.where.not(order_status: pre_sale_statuses)
      pre_sale_carts.each{ |pre_sale_cart| pre_sale_cart.update(country: default_country) }
      ap 'pre_sale_carts : '
      ap pre_sale_carts.count
      ap 'ea updated'
      ordered_carts.each do |ordered_cart|
        if ordered_cart.items.any?
          country_source = ordered_cart.items.first.product || ordered_cart.items.first.product_page
          ordered_cart.update!(country: country_source.country)
        else
          ordered_cart.update!(country: default_country)
        end
      end
      ap 'ordered_carts : '
      ap ordered_carts.count
      ap 'ea updated'
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
