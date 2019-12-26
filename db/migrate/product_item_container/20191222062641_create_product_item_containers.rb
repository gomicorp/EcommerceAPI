class CreateProductItemContainers < ActiveRecord::Migration[6.0]
  def change
    create_table :product_item_containers do |t|
      t.string :name
      t.timestamps
    end
  end
end
