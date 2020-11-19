Rails.application.routes.draw do
  root 'hello#world'

  # global file crud (active_storage)
  resources :files, only: %i[show create destroy]

  constraints format: :json do
    devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations',
        passwords: 'users/passwords'
    }

    draw :partner_center_routes
    draw :store_routes

    draw :common_routes
    draw :sellers_routes

    draw :gomisa_routes
  end

  namespace :haravan do
    namespace :settlement do
      resources :brands, only: %i[index show]
    end
  end

  devise_for :pandals
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
