class AddTimestampToApproveRequest < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :approve_requests, default: Time.zone.now
  end
end
