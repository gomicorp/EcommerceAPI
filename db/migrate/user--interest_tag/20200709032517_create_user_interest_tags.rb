class CreateUserInterestTags < ActiveRecord::Migration[6.0]
  def change
    create_table :user_interest_tags do |t|
      t.references :user, null: false, foreign_key: true
      t.references :interest_tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
