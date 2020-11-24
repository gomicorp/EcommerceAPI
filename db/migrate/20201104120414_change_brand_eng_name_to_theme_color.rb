class ChangeBrandEngNameToThemeColor < ActiveRecord::Migration[6.0]
  def change
    rename_column :brands, :eng_name, :theme_color
  end
end
