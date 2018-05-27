Rails.application.routes.draw do
  
    root "home#index"
    
    get 'users/index'
    get 'edit' => 'users#edit'
    post  'edit'   => 'users#update'

    devise_for :users, controllers: { registrations: "registrations" }
    
    resources :posts 
    
end
