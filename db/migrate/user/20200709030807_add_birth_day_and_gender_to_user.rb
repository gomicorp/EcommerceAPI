class AddBirthDayAndGenderToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :birth_day, :date, null: true
    add_column :users, :gender, :string, null: true
  end
end
