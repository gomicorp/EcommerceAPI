require Rails.root.join('config/routes/helpers/approve_requests_helpers.rb')

namespace :partner do
  namespace :users do
    post '/', to: 'registrations#create'
    post 'sign_in', to: 'sessions#create'
    get 'me', to: 'sessions#show'
  end

  resources :companies, &-> { approve_requests_on(:companies) }
  resources :brands do
    approve_requests_on(:brands)
    scope module: :brands do
      resources :product_item_groups
      resources :product_items
    end
  end
  resources :managers, only: %i[index show create]
  resources :memberships, only: %i[index show create update destroy]


  namespace :office do
    get '/notice', to: 'left_bar#notice'
  end
end
