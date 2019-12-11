class RemoveApproveStatusToCompany < ActiveRecord::Migration[6.0]
  def change
    remove_column :companies, :approve_status
  end
end
