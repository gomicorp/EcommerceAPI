Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  root 'hello#world'

  # global file crud (active_storage)
  resources :files, only: %i[show create destroy]

  constraints format: :json do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }

    draw :api_routes
    draw :partner_center_routes
    draw :store_routes

    draw :common_routes
    draw :sellers_routes

    draw :external_channel_routes
  end

  namespace :haravan do
    namespace :settlement do
      resources :brands, only: %i[index show]
    end
  end

  devise_for :pandals
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
