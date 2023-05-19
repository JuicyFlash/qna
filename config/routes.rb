Rails.application.routes.draw do
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

  resources :questions, concerns: [:votable, :commentable] do
    patch :purge_file, on: :member
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      member do
        patch :purge_file
        patch :best
      end
    end
  end
  resources :rewards, only: :index
  resources :links, only: :destroy

  mount ActionCable.server => '/cable'
end
