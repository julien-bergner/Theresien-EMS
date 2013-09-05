TheresienEms::Application.routes.draw do
  default_url_options host: Rails.application.config.domain

  devise_for :admins

  resources :orders do
    put 'markAsPaid', :on => :member
    put 'sendOrderConfirmation', :on => :member
    put 'skipOrderConfirmation', :on => :member
    put 'sendReceiptOfPayment', :on => :member
    put 'sendTickets', :on => :member
    put 'sendTicketPDFToBrowser', :on => :member
  end

  resources :customers

  match 'front_end/booking' => 'FrontEnd#booking', :as => :booking
  match 'front_end/receiveSelectedSeats' => 'FrontEnd#receiveSelectedSeats', :as => :receiveSelectedSeats
  match 'front_end/switchCustomer' => 'FrontEnd#switchCustomer', :as => :switchCustomer
  match 'front_end/newCustomer' => 'FrontEnd#newCustomer', :as => :newCustomer
  match 'front_end/createCustomer' => 'FrontEnd#createCustomer', :as => :createCustomer
  match 'front_end/editCustomer' => 'FrontEnd#editCustomer', :as => :editCustomer
  match 'front_end/showSummary' => 'FrontEnd#showSummary', :as => :showSummary
  match 'front_end/payment' => 'FrontEnd#payment', :as => :payment
  match 'front_end/goToPaypal' => 'FrontEnd#goToPaypal', :as => :goToPaypal
  match 'front_end/paypalReturn' => 'FrontEnd#paypalReturn', :as => :paypalReturn
  match 'front_end/cancel' => 'FrontEnd#cancel', :as => :cancel
  match 'front_end/bankData' => 'FrontEnd#bankData', :as => :bankData
  match 'front_end/photos' => 'FrontEnd#photos', :as => :photos
  match 'front_end/sponsors' => 'FrontEnd#sponsors', :as => :sponsors
  match 'front_end/contact' => 'FrontEnd#contact', :as => :contact
  match 'front_end/legal' => 'FrontEnd#legal', :as => :legal

  match 'back_end/overview' => 'BackEnd#overview', :as => :overview

  root :to => "FrontEnd#index"
end
