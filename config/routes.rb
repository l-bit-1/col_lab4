Rails.application.routes.draw do
  resources :laboratories
  resources :classlists
  resources :sections
  resources :subjects
  resources :teachers
  resources :students
  resources :departments
end
