class SetCountriesDataToCart < ActiveRecord::Migration[6.0]
  def up
    ApplicationRecord.country_context_with 'global' do
      default_country = Country.th
      Cart.unscoped.all.each do |cart|
        country_source = cart.order_info
        cart_item = cart.items.first
        country_source ||= cart_item&.product_option&.channel
        country_source ||= cart_item&.product_item_barcodes&.first&.product_item
        if country_source
          cart.update!(country: country_source.country)
        else
          cart.update!(country: default_country)
        end
      end
    end
  end

  def down
    # raise ActiveRecord::IrreversibleMigration
  end
end
