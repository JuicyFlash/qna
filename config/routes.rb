Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'

  resources :questions do
    post :answer, on: :member
    resources :answers, shallow: true
  end
end
