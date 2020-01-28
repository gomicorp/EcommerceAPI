class AddIsActiveToProductOptions < ActiveRecord::Migration[6.0]
  def change
    add_column :product_options, :is_active, :boolean, null: false, default: false
  end
end
