Rails.application.routes.draw do
	root 'users#index'

	resources :users
	resources :sessions, only: [:create, :destroy]
	resources :posts, only: [:create, :destroy]
	resources :comments, only: [:create, :destroy]
	resources :friendships, only: [:create, :destroy]
	resources :notifications, only: [:create, :destroy]

	get '/about', to: 'users#about'

	get '/logout', to: 'sessions#destroy'
end
