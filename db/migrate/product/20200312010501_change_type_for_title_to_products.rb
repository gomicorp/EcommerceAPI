class ChangeTypeForTitleToProducts < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :title, :text
  end
end
