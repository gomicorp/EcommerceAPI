class CreateHaravanWebhooks < ActiveRecord::Migration[6.0]
  def change
    create_table :haravan_webhooks do |t|
      t.string :table_name
      t.string :event_name
      t.string :haravan_id
      t.boolean :is_applied

      t.timestamps
    end
  end
end
