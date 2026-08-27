Rails.application.routes.draw do
  resources :subjects
  resources :teachers
  resources :students
  resources :departments
end
