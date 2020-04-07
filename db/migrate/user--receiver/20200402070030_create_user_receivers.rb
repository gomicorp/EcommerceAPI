class CreateUserReceivers < ActiveRecord::Migration[6.0]
  def change
    create_table :user_receivers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :receiver, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_receivers, [:user_id, :receiver_id], unique: true
  end
end
