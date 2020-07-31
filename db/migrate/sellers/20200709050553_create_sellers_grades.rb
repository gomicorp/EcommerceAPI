class CreateSellersGrades < ActiveRecord::Migration[6.0]
  def change
    create_table :sellers_grades do |t|
      t.string :name
      t.float :commission_rate, null: false, default: 0

      t.timestamps
    end
  end
end
