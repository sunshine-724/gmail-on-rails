Rails.application.routes.draw do
  get "home/index"
  get "sessions/create"
  get "sessions/destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root "login#index"
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  post 'logout', to: 'sessions#destroy', as: 'logout'

  get '/home', to: 'home#index', as: :home
  
  #write new mail
  #if reverse to show method, don't nomaly move.
  get 'mail/new', to: 'home#new', as: 'new_mail'
  post 'mail/send', to: 'home#send_mail', as: 'send_mail'
  
  # メール詳細
  get '/mails/:id', to: 'home#show', as: 'show_mail'




  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
