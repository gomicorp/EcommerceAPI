class CreateAdjustment < ActiveRecord::Migration[6.0]
  def change
    create_table :adjustments do |t|
      t.string :reason
      t.string :channel
      t.integer :order_id
      t.date :exported_time
      t.timestamps
    end
  end
end
