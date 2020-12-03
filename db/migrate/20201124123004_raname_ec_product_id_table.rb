class RanameEcProductIdTable < ActiveRecord::Migration[6.0]
  def change
    rename_table :external_channel_product_ids, :external_channel_product_mappers
  end
end
