ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'articles'
  
  map.resources :articles
  map.resources :tags
  map.resources :logins
  map.resources :pages

  map.connect 'articles/:year/:month/:day/:slug', :controller => 'articles', :action => 'show'
  map.connect 'login', :controller => 'logins', :action => 'new'
  map.logout 'logout', :controller => 'logins', :action => 'destroy'
end
