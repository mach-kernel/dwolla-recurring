Rails.application.routes.draw do

  root 'dashboard#home'

  get 'dashboard/home', to: 'dashboard#home'

  get 'dashboard/login', to: 'dashboard#login'
  get 'dashboard/handle_oauth', to: 'dashboard#handle_oauth'
  get 'dashboard/logout', to: 'dashboard#logout'

  get 'dashboard/create', to: 'dashboard#create'
  post 'dashboard/process_scheduled', to: 'dashboard#process_scheduled'

  get 'dashboard/manage', to: 'dashboard#manage'
  get 'dashboard/manage/:id', to: 'dashboard#manage'
  post 'dashboard/change/:id', to: 'dashboard#change'

end
