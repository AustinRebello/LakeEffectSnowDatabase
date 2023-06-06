Rails.application.routes.draw do
  resources :metars do
    collection{
      get :python
      get :downloadCSV
    }
  end
  resources :bufkits do 
    collection {
      get :python
      get :downloadCSV
    }
  end
  resources :snow_reports do
    collection {
      get :file
      post :import
      get :downloadCSV
    }
  end
  resources :lake_effect_snow_events do
    collection {
      get :report
      get :bufkit
      get :metar
    }
  end

  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
