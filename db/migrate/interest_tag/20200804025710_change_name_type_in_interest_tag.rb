class ChangeNameTypeInInterestTag < ActiveRecord::Migration[6.0]
  def change
    change_column :interest_tags, :name, :string
  end
end
