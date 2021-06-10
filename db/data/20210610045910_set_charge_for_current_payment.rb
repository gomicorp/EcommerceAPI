class SetChargeForCurrentPayment < ActiveRecord::Migration[6.0]
  def up
    Payment.where.not(charge_id: [nil, 0]).each do |payment|
      Payment::Charge.create(payment: payment, pg_name: payment.pay_method, pg_id: payment.charge_id)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
