class AddDepthToCategory < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :depth, :integer, null: false, default: 1
  end
end
