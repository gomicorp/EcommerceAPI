class AddArchivedAtColumnToZohomap < ActiveRecord::Migration[6.0]
  def change
    add_column :zohomaps, :archived_at, :datetime
  end
end
