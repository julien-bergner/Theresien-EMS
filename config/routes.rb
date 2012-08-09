TheresienEms::Application.routes.draw do
  resources :customers

  get "home/index"

  match "home/booking" => "home#booking"


  root :to => "home#index"
end
