class AddDescriptionToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :description, :text
  end
end
