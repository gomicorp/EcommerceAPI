class SetCountryForPayment < ActiveRecord::Migration[6.0]
  def up
    Payment.all.each do |payment|
      payment.update(country: payment.order_info.country)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
