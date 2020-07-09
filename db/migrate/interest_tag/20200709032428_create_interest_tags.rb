class CreateInterestTags < ActiveRecord::Migration[6.0]
  def change
    create_table :interest_tags do |t|
      t.json :name

      t.timestamps
    end
  end
end
