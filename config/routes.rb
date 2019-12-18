# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'posts#index'

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

  resources :posts, only: [:index, :show]
  resources :health, only: [:index]
  resources :users


  # Dokku
  get '/check.txt', to: proc {[200, {}, ['it_works']]}
end
