ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email, :encrypted_password, :provider, :uid, :profile_image, :reset_password_token, :reset_password_sent_at, :remember_created_at, :is_admin, :is_manager, :is_seller, :invite_confirmation_token, :default_receiver_id, :default_address_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :encrypted_password, :provider, :uid, :profile_image, :reset_password_token, :reset_password_sent_at, :remember_created_at, :is_admin, :is_manager, :is_seller, :invite_confirmation_token, :default_receiver_id, :default_address_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # index do
  #   selectable_column
  #   id_column
  #   column :name
  #   column :email
  #   actions
  # end
end
