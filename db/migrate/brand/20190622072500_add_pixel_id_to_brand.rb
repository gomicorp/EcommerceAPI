class AddPixelIdToBrand < ActiveRecord::Migration[5.2]
  def change
    add_column :brands, :pixel_id, :bigint
  end
end
