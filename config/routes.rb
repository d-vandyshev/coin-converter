Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'cryptocurrencies', to: 'cryptocurrencies#index'
  get 'conversions', to: 'conversions#index'
  post 'conversions', to: 'conversions#new'
end
