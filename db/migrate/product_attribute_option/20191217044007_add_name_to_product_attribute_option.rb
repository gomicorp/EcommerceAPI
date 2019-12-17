class AddNameToProductAttributeOption < ActiveRecord::Migration[6.0]
  def change
    add_column :product_attribute_options, :name, :string
  end
end
