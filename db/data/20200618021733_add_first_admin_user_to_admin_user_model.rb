class AddFirstAdminUserToAdminUserModel < ActiveRecord::Migration[6.0]
  def up
    AdminUser.create!(root_admin_params)
  end

  def down
    raise ActiveRecord::IrreversibleMigration if Rails.env.production?

    AdminUser.destroy_all
  end

  private

  def root_admin_params
    Rails.application.credentials.dig(:active_admin, :root_admin_user)
  end
end
