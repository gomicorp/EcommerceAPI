class AddUserToReceiver < ActiveRecord::Migration[6.0]
  def change
    add_reference :receivers, :user, null: false, foreign_key: true, index: true
  end
end
