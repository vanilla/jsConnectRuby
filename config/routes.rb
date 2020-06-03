Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # resources :sso
  get 'sso', to: 'sso#index'
  get 'sso/v3', to: 'sso#v3'
end
