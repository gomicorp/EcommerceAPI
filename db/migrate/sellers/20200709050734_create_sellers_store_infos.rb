class CreateSellersStoreInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_store_infos do |t|
      t.text :name, null: false
      t.text :url, null: false
      t.text :comment

      t.timestamps
    end
  end
end
