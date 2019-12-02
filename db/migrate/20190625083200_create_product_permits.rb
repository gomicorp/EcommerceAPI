class CreateProductPermits < ActiveRecord::Migration[5.2]
  def change
    create_table :product_permits do |t|
      t.references :product, foreign_key: true
      t.datetime :permitted_at

      t.timestamps
    end
  end
end
