class AddLastModifiedColumnToZohomap < ActiveRecord::Migration[6.0]
  def change
    add_column :zohomaps, :zoho_updated_at, :datetime
  end
end
