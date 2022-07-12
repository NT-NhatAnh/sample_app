Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users do
      member do
        get :following, to: "follows#following"
        get :followers, to: "follows#followers"
      end
    end
    resources :password_resets, except: %i(show index destroy)
    resources :microposts, :relationships, only: %i(create destroy)
    resources :account_activations, only: :edit
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
