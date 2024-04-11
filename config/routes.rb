Rails.application.routes.draw do
  
  # resources :stocks do
  #   collection do
  #     post :buy  # Route for the 'buy' action
  #   end
  # end
  resources :stocks, only: [:index, :show] do
    post 'transactions/buy', to: 'transactions#buy', on: :member
  end
  

  root 'pages#landing'
  
  get 'admin/pending_traders', to: 'admin_pages#pending_traders'
  resources :admin_pages, path: 'admin', as: 'admin_pages'
  get 'trader/trader_dashboard', to: 'trader_pages#show'
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
