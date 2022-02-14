# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      resources :blogs
    end
  end

  root 'application#root'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
