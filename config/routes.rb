Rails.application.routes.draw do
  get 'movies/show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'movies#home'
  post 'movies', to: 'movies#create'
  get 'movies/:movie_name', to: 'movies#show', as: 'show_movie'
end
