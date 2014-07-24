Crantastic::Application.routes.draw do

  root :to => 'timeline_events#index'

  resources :author_identities, :only => [ :new, :create ]

  resources :authors, :only => [ :index, :show, :create, :edit, :update ]

  resources :password_resets, :except => [ :index, :destroy, :show ]

  resources :priorities, :only => [ :index, :show ], :controller => "tags", :requirements => { :type => "priority" }

  resources :tags, :only => [ :index, :show, :edit, :update ]

  resources :task_views, :only => [ :index, :show ], :controller => "tags", :requirements => { :type => "task_view" }

  resources :timeline_events, :only => [ :index, :show ]

  resources :users, :except => [:destroy] do
    member do
      match :regenerate_api_key, via: [:get, :post]
    end
  end

  resources :versions, :only => [:index, :create] do
    collection do
      get :feed
    end
  end

  resources :votes, :only => [ :create ]

  resources :weekly_digests, :only => [ :index, :show ]

  # Nested resources
  # The following rule allows us to capture links such as /packages/data.table,
  # before redirecting them to the correct URL. Note the negative lookahead for
  # valid formats, so that we don't break e.g. .xml urls.

  # TODO This can probably go in the resources somehow?
  match 'packages/:id', :to => 'packages#show', :requirements => { :id => /.+\.(?!xml|atom|html|bibjs).*/ }
  resources :packages, :except => [:update, :edit] do
    collection do
      get :all
      get :feed
      match :search, via: [:get, :post]
    end
    member do
      post :toggle_usage
    end
    resources :versions, :only => [ :index, :show ]
    resources :ratings, :except => [ :edit, :update ]
    resources :reviews
    resources :taggings, :only => [ :new, :create, :destroy ]
  end

  resources :reviews do
    resources :review_comments, :only => [ :new, :create, :show ]
  end

  # Singleton resources
  resource :search, :controller => "search", :only => [ :show ]
  resource :session, only: [:new, :create, :destroy] do
    collection do
      get :rpx_token
    end
  end

  match 'about', :to => 'static#about'
  match 'email_notifications', :to => 'static#email_notifications'
  match 'error_404', :to => 'static#error_404'
  match 'error_500', :to => 'static#error_500'

  # Named routes
  match 'daily/:day', :controller => 'weekly_digests', :action => 'daily'
  match 'signup', :controller => 'users', :action => 'new'
  match 'thanks', :controller => 'users', :action => 'thanks'
  match 'activate/:activation_code', :controller => 'users', :action => 'activate'
  match 'login', :controller => 'sessions', :action => 'new'
  match 'logout', :controller => 'sessions', :action => 'destroy'
  match 'popcon', :controller => 'packages', :action => 'index', :popcon => '1'

  match 'versions/:id/:action', :controller => 'versions', :as => 'version_extras'

  # TODO No idea what this is wanting to do
  #map.error '*url', :controller => 'static', :action => 'error_404'
end
