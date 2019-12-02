class AddApproveStatusToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :approve_status, :integer, null: false, default: 0
  end
end
