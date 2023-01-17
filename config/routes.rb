Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'

  resources :questions do
    patch :purge_file, on: :member
    resources :answers, shallow: true do
      member do
        patch :purge_file
        patch :best
      end
    end
  end

  resources :links, only: :destroy
end
