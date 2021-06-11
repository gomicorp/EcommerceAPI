class RedefinePayMethodForPayment < ActiveRecord::Migration[6.0]
  def up
    Payment.where(pay_method: 'card').update_all(pay_method: :omise, updated_at: DateTime.now)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
