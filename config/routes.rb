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
      get :map
    }
  end
  resources :lake_effect_snow_events do
    collection {
      get :report
      get :bufkit
      get :metar
      get :search
      get :advancedSearch
      get :searchResults
      get :advancedSearchResults
    }
  end
  get 'home/404'
  get 'home/record_not_found'
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '*unmatched_route', to: 'application#not_found'
end
