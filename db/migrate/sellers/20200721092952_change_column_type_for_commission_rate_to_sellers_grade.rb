class ChangeColumnTypeForCommissionRateToSellersGrade < ActiveRecord::Migration[6.0]
  def up
    change_column :sellers_grades, :commission_rate, :decimal, precision: 10, scale: 2
  end
  def down
    change_column :sellers_grades, :commission_rate, :float
  end
end
