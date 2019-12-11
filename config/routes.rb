Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  # global file crud (active_storage)
  resources :files, only: %i[show create destroy]

  draw :partner_center_routes

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
end
