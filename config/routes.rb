Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }

  resources :files, only: %i[show create destroy]

  namespace :partner do
    namespace :users do
      post '/', to: 'registrations#create'
      get '/:id', to: 'registrations#show'
      post 'sign_in', to: 'sessions#create'
    end

    resources :companies
    resources :managers, only: %i[index show create]
    resources :memberships, only: %i[index show create update destroy]
    resources :brands
  end
end
