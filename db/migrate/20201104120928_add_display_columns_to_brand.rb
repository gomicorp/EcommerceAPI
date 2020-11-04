class AddDisplayColumnsToBrand < ActiveRecord::Migration[6.0]
  def change
    add_column :brands, :subtitle, :string
    add_column :brands, :slogan, :string
    add_column :brands, :description, :text
  end
end
