TheresienEms::Application.routes.draw do
  resources :customers



  match 'front_end/booking' => 'FrontEnd#booking', :as => :booking
  match 'front_end/photos' => 'FrontEnd#photos', :as => :photos
  match 'front_end/sponsors' => 'FrontEnd#sponsors', :as => :sponsors
  match 'front_end/contact' => 'FrontEnd#contact', :as => :contact
  match 'front_end/legal' => 'FrontEnd#legal', :as => :legal



  root :to => "FrontEnd#index"
end
