Rails.application.routes.draw do

  devise_for :users, :controllers => { omniauth_callbacks: 'omniauth_callbacks' }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
  get '/_=_' => 'others#index'

  #
  # API ROUTES
  #
  namespace :api, path: '/', constraints: { subdomain: 'api' }, :defaults => { :format => 'json' }  do
    get 'getKey/:id' => 'apisecurity#provideKey', constraints: {id: /[0-9]+/}
    get 'getSocialToken/:uid/:provider' => 'apisecurity#getSocialToken'
    match 'social-login' => 'apisecurity#socialLogin', via: [:post, :options]
    match 'login' => 'apisecurity#login', via: [:post, :options]

    resources :albums, only: [:index, :show] do #ok
      collection do
        get 'find' => 'albums#find'
        match 'addcomment/:id' => 'albums#addcomment', constraints: {id: /[0-9]+/}, via: [:post, :options]
        get ':id/comments' => 'albums#getcomments'
      end
    end

    resources :ambiances, only: [:index, :show]

    resources :battles, only: [:index, :show] do #ok
      collection do
        get 'find' => 'battles#find'
        match ':id/vote' => 'battles#vote', via: [:post, :options]
      end
    end

    get 'carts/my_cart' => 'carts#show'
    match 'carts/save' => 'carts#save', via: [:post, :options]
    get 'carts/destroy' => 'carts#destroy' #ok

    resources :concerts, only: [:index, :show] do #ok
      collection do
        get 'find' => 'concerts#find'
      end
    end

    match 'feedbacks/save' => 'feedbacks#save', via: [:post, :options] #ok

    resources :genres, only: [:index, :show] do #ok
    end
    match 'gifts/save' => 'gifts#save', via: [:post, :options] #ok

    resources :influences, only: [:index] do #ok
    end

    resources :languages, only: [:index] do #ok
    end

    resources :listenings, only: [:index, :show] do #ok
      collection do
        get 'find' => 'listenings#find'
        match 'save' => 'listenings#save', via: [:post, :options]
        get 'around/:lat/:lng/:range' => 'listenings#around', :constraints => {:lat => /\-*\d+.\d+/ , :lng => /\-*\d+.\d+/ , :range => /\d+/}
      end
    end

    resources :likes do #ok
      collection do
        match 'save' => 'likes#save', via: [:post, :options]
        get 'destroy' => 'likes#destroy'
      end
    end

    resources :messages, only: [:show] do #ok
      collection do
        get 'find' => 'messages#find'
        match 'save' => 'messages#save', via: [:post, :options]
        get 'conversation/:id' => 'messages#conversation'
      end
    end

    resources :musics, only: [:index, :show] do #ok
      collection do
        get 'find' => 'musics#find'
        match 'addcomment/:id' => 'musics#addcomment', constraints: {id: /[0-9]+/}, via: [:post, :options]
        get 'get/:id' => 'musics#get', constraints: {id: /[0-9]+/}, format: 'mp3' #verifier si ça fonctionne
        match 'addtoplaylist' => 'musics#addtoplaylist', via: [:post, :options]
        get 'delfromplaylist' => 'musics#delfromplaylist'
        get ':id/comments' => 'musics#getcomments'
        get 'getNotes' => 'musics#getNotes'
        match ':id/note/:note' => 'musics#setNotes', via: [:post, :options]
      end
    end

    resources :news, only: [:index, :show] do #ok
      collection do
        get 'find' => 'news#find'
        match 'addcomment/:id' => 'news#addcomment', constraints: {id: /[0-9]+/}, via: [:post, :options]
        get ':id/comments' => 'news#getcomments'
      end
    end

    resources :notifications, only: [:show] do #ok
      collection do
        match ':id/read' => 'notifications#readNotif', via: [:post, :options]
        get 'find' => 'notifications#find'
        get 'destroy' => 'notifications#destroy'
      end
    end

    resources :packs, only: [:index, :show] do #ok
      collection do
        get 'find' => 'packs#find'
      end
    end

    resources :playlists, only: [:show] do #ok
      collection do
        get 'find' => 'playlists#find'
        match 'save' => 'playlists#save', via: [:post, :options]
        match 'update' => 'playlists#update', via: [:post, :options]
        get 'destroy' => 'playlists#destroy'
      end
    end

    resources :purchases, only: [] do
      collection do
        match 'buycart' => 'purchases#buycart', via: [:post, :options] #ok
        match 'buypack' => 'purchases#buypack', via: [:post, :options] #ok
      end
    end

    get 'search' => 'searchs#search' #ok
    get 'suggest' => 'suggestions#show' #ok
    get 'suggestv2' => 'suggestions#showTwo' #ok
    match 'musicalPast' => 'suggestions#getMusicalPast', via: [:post, :options] #ok

    resources :tweets, only: [:index, :show] do #ok
      collection do
        get 'find' => 'tweets#find'
        match 'save' => 'tweets#save', via: [:post, :options]
        get 'destroy' => 'tweets#destroy'
        get 'flux' => 'tweets#flux'
      end
    end

    resources :users, only: [:index, :show] do #ok
      collection do
        get "getIdentities" => 'users#getIdentities'

        get 'artists' => 'users#artists'
        get 'find' => 'users#find'
        match 'save' => 'users#save', via: [:post, :options]
        match 'update' => 'users#update', via: [:post, :options]
        get 'getmusics' => 'users#getmusics'
        get ':id/isartist' => 'users#isArtist'

        match 'follow' => 'users#follow', via: [:post, :options]
        match 'unfollow' => 'users#unfollow', via: [:post, :options]
        match 'addfriend' => 'users#addfriend', via: [:post, :options]
        match 'delfriend' => 'users#delfriend', via: [:post, :options]

        get ':id/friends' => 'users#getFriends'
        get ':id/follows' => 'users#getFollows'
        get ':id/followers' => 'users#getFollowers'

        match 'upload' => 'users#uploadImg', via: [:post, :options]
        match 'linkSocial' => 'users#linkSocial', via: [:post, :options]
      end
    end
  end

  namespace :artist, path: '/', constraints: { subdomain: 'artist' } do
    # Route of the views
    root 'mains#home'
    get '/tour' => 'tours#index'
    get '/musics' => 'musics#index'
    get '/musics/propose' => 'musics#propose'
    get '/tour/edit/:id' => 'tours#edit', as: "tour_edit"
    get '/meet' => 'meets#index'
    get '/meet/all' => 'meets#show'

    # AJAX
      # Main
      get '/stats' => 'mains#stats'
      get '/comments' => 'mains#getLastComments'
      get '/tweets' => 'mains#getLastTweets'

      # Tour
      patch '/tour/update/:id' => 'tours#update', as: "tour_update"
      get '/tour/delete/:id' => 'tours#delete', as: "tour_delete"
      match '/tour/addconcert' => 'tours#create_concert', via: [:post, :options]

      # Music
      match '/musics/upload' => 'musics#uploadMusic', via: [:post, :options]
      match '/musics/createAlbum' => 'musics#uploadAlbum', via: [:post, :options]
      match '/musics/updateMusic' => 'musics#updateMusic', via: [:post, :options]
      match '/musics/updateAlbum' => 'musics#updateAlbum', via: [:post, :options]
      get '/musics/getPropose' => 'musics#getPropose'
      match '/musics/proposeAlbums' => 'musics#proposeAlbums', via: [:post, :options]
      match '/musics/createAlbumSoftware' => 'musics#createAlbum', via: [:post, :options]
      match '/musics/uploadRediff' => 'musics#uploadRediff', via: [:post, :options]

      # Meet
      match '/meet/save' => 'meets#save', via: [:post, :put]
      get '/meet/delete/:id' => 'meets#destroy', as: "meet_destroy"
  end

  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  resources :albums, only: [:show]
  resources :battles, only: [:index, :show]
  get '/carts/my_cart' => 'carts#index'
  resources :concerts, only: [:index]
  resources :feedbacks, only: [:new, :create]
  resources :gifts
  resources :listenings, only: [:index]
  resources :news, only: [:index, :show]
  resources :notifications, only: [:index]
  resources :packs, only: [:index, :show]
  resources :playlists, only: [:show]
  resources :purchases
  resources :tweets
  
  resources :users do
    collection do
      get "friendlist" => 'users#friendlist'
    end
  end
  
  resources :votes

  get '/explorer(/:influence(/:genre))' => 'others#explorer', as: "explorer"
  get 'messages' => 'chats#index'
  get '/my_music' => 'others#discotheque'
  get '/search/:value' => 'others#search'

  get '/purchase/cart' => 'purchases#buyCart'
  get '/successCallback/cart' => 'purchases#paymentCallbackCart'
  get '/cancelCallback/cart' => 'purchases#cancelCallbackCart'

  get '/purchase/pack/:id' => 'purchases#buyPack'
  get '/successCallback/pack/:id/' => 'purchases#paymentCallbackPack'
  get '/cancelCallback/pack/:id/' => 'purchases#cancelCallbackPack'

  get '/soundcloudCallback' => 'others#soundcloud'

  root 'others#index'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
