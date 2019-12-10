require Rails.root.join('config/routes/helpers/approve_requests_helpers.rb')

namespace :partner do
  namespace :users do
    post '/', to: 'registrations#create'
    get '/:id', to: 'registrations#show'
    post 'sign_in', to: 'sessions#create'
  end

  resources :companies, &-> { approve_requests_on(:companies) }
  resources :brands, &-> { approve_requests_on(:brands) }
  resources :managers, only: %i[index show create]
  resources :memberships, only: %i[index show create update destroy]

  namespace :office do
    get '/notice', to: 'left_bar#notice'
  end
end
