Rails.application.routes.draw do
  resources :stocks, only: [:index, :show]

  root 'home#landing'

  get 'home/trader', to: 'home#trader', as: :home_trader
  get 'home/admin', to: 'home#admin', as: :home_admin

  devise_for :admins,  controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations'
  }
  
  devise_for :traders,  controllers: {
     sessions: 'traders/sessions',
     registrations: 'traders/registrations'
   }
   
end
