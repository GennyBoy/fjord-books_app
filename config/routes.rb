Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  resources :books
  devise_scope :user do
    get '/users/:id', to: 'users/users#show', as: :user
    get '/users', to: 'users/users#index'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'books#index'
end
