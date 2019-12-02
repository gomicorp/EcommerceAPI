class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.references :order_info, foreign_key: true
      t.string :pay_method
      t.boolean :paid
      t.datetime :paid_at

      t.timestamps
    end
  end
end
