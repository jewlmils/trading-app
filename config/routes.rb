Rails.application.routes.draw do
  root 'pages#landing'

  resources :portfolios
  resources :stocks, only: [:index, :show] do
    post 'transactions/buy', to: 'transactions#buy', on: :member
    post 'transactions/sell', to: 'transactions#sell', on: :member
  end
  
  resources :transactions, only: [:index] do
    collection do
      post :buy
      post :sell
    end
  end
  
  get 'admin/pending_traders', to: 'admin_pages#pending_traders'
  resources :admin_pages, path: 'admin', as: 'admin_pages'
  get 'trader/trader_dashboard', to: 'trader_pages#show'
  post 'trader/trader_dashboard', to: 'trader_pages#deposit'


  devise_for :admins,  controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations'
  }
  
  devise_for :traders,  controllers: {
     sessions: 'traders/sessions',
     registrations: 'traders/registrations'
   }
   
  # resources :stocks do
  #   collection do
  #     post :buy  # Route for the 'buy' action
  #   end
  # end
end
