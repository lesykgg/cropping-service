Rails.application.routes.draw do
  root 'images#new'

  resources :images, except: %i[index edit destroy]
end
