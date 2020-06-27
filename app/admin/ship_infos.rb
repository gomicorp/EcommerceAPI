ActiveAdmin.register ShipInfo do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :order_info_id, :receiver_name, :receiver_tel, :receiver_email, :loc_state, :loc_city, :loc_district, :loc_detail, :ship_type, :ship_amount, :user_memo, :postal_code
  #
  # or
  #
  # permit_params do
  #   permitted = [:order_info_id, :receiver_name, :receiver_tel, :receiver_email, :loc_state, :loc_city, :loc_district, :loc_detail, :ship_type, :ship_amount, :user_memo, :postal_code]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

end
