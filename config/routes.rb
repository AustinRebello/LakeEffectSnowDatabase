Rails.application.routes.draw do
  resources :metars
  resources :bufkits
  resources :snow_reports do
    collection {
      get :file
      post :import
    }
  end
  resources :lake_effect_snow_events

  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
