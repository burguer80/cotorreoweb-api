# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts

  devise_for :users,
             path: '',
             path_names: {
                 sign_in: 'login',
                 sign_out: 'logout',
                 registration: 'signup'
             },
             controllers: {
                 sessions: 'sessions',
                 registrations: 'registrations'
             }

  authenticate :user do
    resources :posts, only: [:new, :create, :edit, :update, :destroy]
  end

  resources :users
  resources :posts, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
