class CreatePaymentCharges < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_charges do |t|
      t.string :pg_name, null: false
      t.string :pg_id
      t.string :supplement
      t.references :payment, foreign_key: true
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end
