class ChangeTextForUserMemo < ActiveRecord::Migration[6.0]
  def change
    change_column :ship_infos, :user_memo, :text
  end
end
