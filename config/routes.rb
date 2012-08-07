TheresienEms::Application.routes.draw do
  resources :customers

  get "home/index"

  root :to => "home#index"
end
