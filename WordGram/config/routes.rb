Rails.application.routes.draw do
  # get 'users/new'
  #
  # get 'users/:id/edit'
  #
  # delete 'users/:id'
  #
  # patch 'users/:id'
  #
  # put 'users/:id'

  # Root is the unauthenticated path
  root 'sessions#unauth'

  # Sessions URL
  get 'sessions/unauth', as: :login
  post 'sessions/login', as: :signin
  delete 'sessions/logout', as: :logout

  get 'posts/interests', to: 'posts#interests', as: :interest_posts
  # Resourceful routes for posts
  resources :posts

  resources :users

  post 'posts/:id/comment', to: 'posts#comment', as: :comment_on_post

end
