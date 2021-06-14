class SetCountryForPayment < ActiveRecord::Migration[6.0]
  def up
    Payment.all.each do |payment|
      if payment.order_info.nil?
        payment.destroy!
        next
      end
      payment.update(country: payment.order_info.country)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
