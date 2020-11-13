class AddClassificationFieldToInterestTag < ActiveRecord::Migration[6.0]
  def change
    add_column :interest_tags, :created_by, :string
  end
end
