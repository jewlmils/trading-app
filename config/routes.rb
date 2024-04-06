Rails.application.routes.draw do
  root 'pages#landing'
  resources :admin_pages, as: 'admin_pages'
  get 'pages/trader', to: 'pages#trader', as: :pages_trader

  devise_for :admins,  controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations'
  }
  
  devise_for :traders,  controllers: {
     sessions: 'traders/sessions',
     registrations: 'traders/registrations'
   }
   
end
