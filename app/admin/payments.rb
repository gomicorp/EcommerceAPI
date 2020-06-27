ActiveAdmin.register Payment do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :order_info_id, :pay_method, :paid, :paid_at, :amount, :total_price_sum, :total_discount_amount, :delivery_amount, :expire_at, :cancelled, :cancel_message, :charge_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:order_info_id, :pay_method, :paid, :paid_at, :amount, :total_price_sum, :total_discount_amount, :delivery_amount, :expire_at, :cancelled, :cancel_message, :charge_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
