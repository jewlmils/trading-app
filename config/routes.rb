Rails.application.routes.draw do
  root 'pages#landing'

  get 'pages/trader', to: 'pages#trader', as: :pages_trader
  get 'pages/admin', to: 'admin_pages#index', as: :pages_admin

  devise_for :admins,  controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations'
  }
  
  devise_for :traders,  controllers: {
     sessions: 'traders/sessions',
     registrations: 'traders/registrations'
   }
   
end
