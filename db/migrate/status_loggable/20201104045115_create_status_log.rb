class CreateStatusLog < ActiveRecord::Migration[6.0]
  def change
    create_table :status_logs do |t|
      t.references :status_code, null: false, foreign_key: true
      t.string :code, null: false
      t.references :loggable, polymorphic: true, null: false
      t.json :extra_info

      t.timestamps

      t.index [:status_code_id, :loggable_type], name: "index_status_codes_on_loggable_type"
    end
  end
end
