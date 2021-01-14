class ChangeColumnTypeToTextForProfileImageInUser < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :profile_image, :text
  end
end
