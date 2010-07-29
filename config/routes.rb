ActionController::Routing::Routes.draw do |map|
 
  map.report_job_bunker "/reports/explosive_bunker_based/:location", :controller => "reports", :action => "explosive_bunker_based"
  map.report_job_location "/reports/explosive_location_based/:location", :controller => "reports", :action => "explosive_location_based"
  map.report_job_fmt "/reports/fmt_in_out", :controller => "reports", :action => "fmt_in_out"
  map.report_job_summary "/reports/job_summary", :controller => "reports", :action => "job_summary"
  map.report_explosives_quantities "/reports/explosives_quantities", :controller => "reports", :action => "explosives_quantities"
  map.movement_index "/movement", :controller => "movement", :action => "index" 
  map.movement_create "/movement/create", :controller => "movement", :action => "create" 
  map.resources :mail_managers

  map.resources :orders

  map.new_job "/jobs/new", :controller => 'jobs', :action => 'new'
  map.edit_job "/jobs/edit/:id", :controller => 'jobs', :action => 'edit', :requirements => { :id => /\d+/}
  map.update_product "/jobs/update_product", :controller => 'jobs', :action => 'update_product'
  map.remove_product "/jobs/remove_product", :controller => 'jobs', :action => 'remove_product'
  map.add_products "/jobs/add_products", :controller => 'jobs', :action => 'add_products'
  map.view_job "/jobs/:id", :controller => 'jobs', :action => 'show', :requirements => { :id => /\d+/}
  map.close_job "/jobs/close/:id", :controller => 'jobs', :action => 'close', :requirements => { :id => /\d+/}
  map.close_job_action "/jobs/close_job", :controller => 'jobs', :action => 'close_job', :requirements => { :id => /\d+/} 
  map.notify_low_inventory "/jobs/notify_low_inventory", :controller => 'jobs', :action => 'notify_low_inventory' 
  
  map.receive "/orders/receive", :controller => 'orders', :action => 'receive'
  map.get_existing_quantity "/products/get_existing_quantity", :controller => 'products', :action => 'get_existing_quantity'
  map.update_inventory "/products/update_inventory", :controller => 'products', :action => 'update_inventory'
  map.resources :bunkers

  map.resources :products

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.activate_user "/users/activate/:id", :controller => 'users', :action => 'activate'
  map.resources :users
  
  map.resource :session
  #map.root :controller => 'main'
  map.home '', :controller => 'main', :action => 'index' 
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
