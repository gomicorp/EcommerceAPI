class CreateSellersSelectedProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_selected_products do |t|
      t.references :store_info, null: false, foreign_key: { to_table: :sellers_store_infos }
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
