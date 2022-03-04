# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      resources :blogs
      resources :login, only: :create
      resource :logout, only: :destroy
      resources :refresh_tokens, only: :create
      resources :users, only: :create
      resource :me, only: :show
    end

    namespace :v2 do
      resources :blogs
      resources :login, only: :create
      resource :logout, only: :destroy
      resources :refresh_tokens, only: :create
      resources :users, only: :create
      resource :me, only: :show
    end
  end

  root to: redirect('/api-docs')
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
