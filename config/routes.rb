Rails.application.routes.draw do
  resources :stocks, only: [:index, :show]

  devise_for :admins,  controllers: {
        sessions: 'admins/sessions',
        registrations: 'admins/registrations'
      }
      
  devise_for :traders,  controllers: {
        sessions: 'traders/sessions',
        registrations: 'traders/registrations'
      }

  root 'home#landing'
  get 'home/landing'
  get 'home/trader'
  get 'home/admin'
end
