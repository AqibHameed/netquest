Rails.application.routes.draw do
namespace :api do
    resources :posts
    devise_for :users, controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions'
    }
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
