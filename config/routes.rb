CNN::Application.routes.draw do
  devise_for :users
  
  # The priority is based upon order of creation:
  # first created -> highest priority.
  root to: 'home#index'

  match "/pages/demo" => "pages#demo"
  match "/pages/load_more" => "pages#load_more"
  match "/feed" => "feed#index"
  match "/feed/load_more" => "feed#load_more"
  match "/pages/:id/about" => "pages#about"
   match "/pages/delete_picture/:id" => "pages#delete_picture"
  resources :pages
  resources :tech_tags
  match "/likes/ajax_like" => "likes#ajax_like"
  resources :likes 
  
  match "/projects/project_type/:id" => "projects#project_type"
  match "/projects/project_layout" => "projects#project_layout"
  match "/comments/loadmore" => "comments#loadmore"
  match "/notifications" => "notifications#index"
  match "/notifications/old" => "notifications#old"
  match "/projects/delete_picture/:id" => "projects#delete_picture"

  resources :comments
  
  #need to put these inside of a collection resource to get access to project_type_projects_path variable.
  resources :projects do 
    collection do
      get 'project_type'
      get 'project_layout'
      get 'new_project'
    end
  end

  match "/sporeprint/:id" => "sporeprint#show"

  post 'pusher/auth'

  mount Resque::Server, :at => '/resque'

  #match ':controller(/:action(/:id))'

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
