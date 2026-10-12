Rails.application.routes.draw do
  root "home#index"

  resources :laboratories
  resources :classlists
  resources :sections
  resources :subjects
  resources :teachers
  resources :students
  resources :departments
end
