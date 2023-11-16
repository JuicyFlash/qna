Rails.application.routes.draw do
  use_doorkeeper
  concern :votable do
    member do
      patch :like
      patch :dislike
    end
  end

  concern :commentable do
    member do
      get :comments
      post :create_comment
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  resources :questions, concerns: %i[votable commentable] do
    patch :purge_file, on: :member
    resources :answers, concerns: %i[votable commentable], shallow: true do
      member do
        patch :purge_file
        patch :best
      end
    end
  end
  resources :rewards, only: :index
  resources :links, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
      end
      resources :questions, only: %i[index show] do
        resources :answers, only: %i[index show], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
