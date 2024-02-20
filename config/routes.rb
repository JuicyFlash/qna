require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

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
    member do
      patch :purge_file
    end
    resources :answers, concerns: %i[votable commentable], shallow: true do
      member do
        patch :purge_file
        patch :best
      end
    end

  end
  resources :subscriptions, only: %i[create destroy], shallow: true
  resources :rewards, only: :index
  resources :links, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
      end
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
