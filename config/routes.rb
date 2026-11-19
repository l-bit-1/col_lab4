Rails.application.routes.draw do
  root "home#index"

  resource:session, only: [:new,:create,:destroy] 

  resources :laboratories
  resources :classlists
  resources :sections
  resources :subjects
  resources :departments

  resources :students do
    collection do
     get :search
   end
  end

  resources :teachers do
  collection do
    get :search
   end
  end
end
