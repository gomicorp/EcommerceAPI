class CreateReceivers < ActiveRecord::Migration[6.0]
  def change
    create_table :receivers do |t|
      t.string :name
      t.string :tel
      t.string :email

      t.timestamps
    end
  end
end
