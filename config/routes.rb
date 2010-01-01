ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'home'
  
  map.resources :articles
  map.resources :tags
  map.resources :user_sessions
  map.resources :pages

  map.connect 'articles/:year/:month/:day/:slug', :controller => 'articles', :action => 'show'
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
end
