Rails.application.routes.draw do
  
  root 'dashboard#home'

  get 'dashboard/home', to: 'dashboard#home'

  get 'dashboard/login', to: 'dashboard#login'
  get 'dashboard/handle_oauth', to: 'dashboard#handle_oauth'
  get 'dashboard/logout', to: 'dashboard#logout'

end
