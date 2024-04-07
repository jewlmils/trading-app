Rails.application.routes.draw do
  
  resources :stocks, only: [:index, :show]

  root 'pages#landing'
  
  get 'admin/pending_traders', to: 'admin_pages#pending_traders'
  resources :admin_pages, path: 'admin', as: 'admin_pages'
  get 'trader/trader_dashboard', to: 'pages#trader', as: :pages_trader
  # get 'trader/thankyou', to: 'pages#thankyou'

  devise_for :admins,  controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations'
  }
  
  devise_for :traders,  controllers: {
     sessions: 'traders/sessions',
     registrations: 'traders/registrations'
   }
   
end
