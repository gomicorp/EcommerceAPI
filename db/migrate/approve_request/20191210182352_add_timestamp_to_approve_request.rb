class AddTimestampToApproveRequest < ActiveRecord::Migration[6.0]
  def change
    change_table :approve_requests do |t|
      t.timestamps null: false, default: Time.at(1575969832)
    end
  end
end
