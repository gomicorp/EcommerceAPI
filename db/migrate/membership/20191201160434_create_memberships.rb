class CreateMemberships < ActiveRecord::Migration[6.0]
  def change
    create_table :memberships do |t|
      t.references :company, null: false, foreign_key: true
      t.references :manager, null: false, foreign_key: { to_table: :users }
      t.integer :role, null: false, default: 0
      t.boolean :accepted, null: false, default: false

      t.timestamps
    end
  end
end
