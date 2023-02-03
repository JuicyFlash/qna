Rails.application.routes.draw do
  concern :votable do
    member do
      patch :like
      patch :dislike
    end
  end

  devise_for :users
  root to: 'questions#index'

  resources :questions, concerns: [:votable] do
    patch :purge_file, on: :member
    resources :answers, concerns: [:votable], shallow: true do
      member do
        patch :purge_file
        patch :best
      end
    end
  end
  resources :rewards, only: :index
  resources :links, only: :destroy
end
