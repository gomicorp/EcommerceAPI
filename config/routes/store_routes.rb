namespace :store do
  resources :order_infos do
    scope module: :order_infos, except: [:new, :edit, :create] do
      resource :ship_info do
        patch :status, as: 'change_status'
        patch :track
        get :edit
      end
    end
  end
end
