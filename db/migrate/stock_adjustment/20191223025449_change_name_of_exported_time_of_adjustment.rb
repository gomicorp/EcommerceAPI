class ChangeNameOfExportedTimeOfAdjustment < ActiveRecord::Migration[6.0]
  def change
    rename_column :adjustments, :exported_time, :exported_at
  end
end
