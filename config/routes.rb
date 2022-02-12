Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: 'books#index'
  resources :books
  resources :users, only: %i(index show) do
    member do
      get :following, :followers, controller: :follow_relationships
    end
  end
  resources :follow_relationships, only: %i(create destroy)
end
