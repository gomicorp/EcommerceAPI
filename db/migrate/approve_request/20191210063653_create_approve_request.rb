class CreateApproveRequest < ActiveRecord::Migration[6.0]
  def change
    create_table :approve_requests do |t|
      t.integer :status, null: false, default: 0
      t.references :approvable, polymorphic: true
      t.boolean :alive, null: false, default: true
    end
  end
end
