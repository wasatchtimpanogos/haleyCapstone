# frozen_string_literal: true

Rails.application.routes.draw do
  api_guard_routes for: "users", defaults: {format: :json}, controller: {
    registration: "users/registration",
    authentication: "users/authentication"
    # passwords: "users/passwords",
    # tokens: "users/tokens"
  }

  resources :users, defaults: {format: :json}
  resources :user_connections, defaults: {format: :json}, only: [:create, :destroy], path: "followerships"
  resources :posts, defaults: {format: :json} do
    resource :likes, defaults: {format: :json}, only: [:create, :destroy]
  end
  root "users#index", defaults: {format: :json}
end
