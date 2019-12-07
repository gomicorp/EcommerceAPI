class AddInviteConfirmationTokenToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :invite_confirmation_token, :string
  end
end
