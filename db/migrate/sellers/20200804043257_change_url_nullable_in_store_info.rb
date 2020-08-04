class ChangeUrlNullableInStoreInfo < ActiveRecord::Migration[6.0]
  def change
    change_column :sellers_store_infos, :url, :text, null: true
  end
end
