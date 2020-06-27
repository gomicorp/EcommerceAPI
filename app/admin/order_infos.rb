ActiveAdmin.register OrderInfo.includes(cart: :country) do
  menu priority: 2, label: proc { I18n.t('activerecord.models.order_info') }

  includes cart: :country, channel: :country

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :finished, :cart_id, :enc_id, :admin_memo, :channel_id, :country_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:finished, :cart_id, :enc_id, :admin_memo, :channel_id, :country_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  status_dic = {
    pay: '입금대기',
    paid: '결제완료',
    'cancel-request': '취소요청',
    'cancel-complete': '취소완료'
  }
  status_dic.each do |key, label|
    scope(key) { |order_infos| order_infos.stage_in(key) }
  end
  # scope_to :all, if: -> { OrderInfo.all }

  index do
    selectable_column
    id_column
    column :order_status
    column :cart
    column :finished
    column :ordered_at
    column :country
    column :channel
    actions
  end
end
