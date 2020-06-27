ActiveAdmin.register StatusCode do
  menu priority: 3, label: proc { I18n.t('activerecord.models.status_code') }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :code, :comment
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :code, :comment]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
