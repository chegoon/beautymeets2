Beautymeets2::Application.routes.draw do

  root :to => 'welcome#index'
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :devices

  resources :posts

  resources :events do
    resources :pictures, :comments
  end

  match 'notifications' => 'activities#index'

  resources :boards do 
    resources :pictures, :comments
  end

  resources :posts do 
    resources :pictures, :comments
  end

  get 'bookmarks/toggle', to: "bookmarks#toggle"

  match '/users/auth/:provider/callback' => 'authentications#create'
  
  resources :authentications

  resources :bookmarks

  get 'members/:id/tutorials', to: 'members#tutorials', as: :member_tutorials
  get 'members/:id/beautyclasses', to: 'members#beautyclasses', as: :member_beautyclasses
  get 'members/:id/bookmarks', to: 'members#bookmarks', as: :member_bookmarks
  get 'members/:id/notifications', to: 'members#notifications', as: :member_notifications

  get "activities/index"

  get "welcome/index"


  resources :checkouts

  resources :welcome

  resources :activities
  
  resources :user_steps

  resources :shops do
    resources :locations, :beautystars
  end

  resources :locations

  resources :members 

  resources :tutorials do 
    resources :comments, :pictures
    resources :items do 
      match 'unitemize' => 'items#unitemize', :via => [:delete]     
    end
    get :autocomplete_item_name, :on => :collection   
    #match 'tutorials/:tutorial_id/items/:id/unitemize' => 'items#unitemize', :via => [:delete]
  end

  resources :beautyclasses do 
    resources :shops, :pictures, :comments, :locations, :checkouts
    get :autocomplete_location_name, :on => :collection   
  end

  resources :items do
    resources :pictures, :tutorials, :videos, :comments
    get :autocomplete_brand_name, :on => :collection  
  end

  get "pictures/index"
  get "pictures/new"

  resources :beautystars do 
    resources :pictures, :comments
  end


  get 'tags/:tag', to: 'info#tag', as: :tag

  resources :categories 
  
  resources :brands do
    resources :pictures
  end

  resources :companies

  resources :videos do 
    resources :comments, :items
  end

  resources :video_groups do 
    collection do 
      get :update_groups
    end
  end

  devise_for :users, :path_names => { :sign_up => "join", :sign_in => "login", :sign_out => "logout", :edit_name => "edit_name", :edit_avatar => "edit_avatar", :edit_password => "edit_password" }, controllers: { registrations: "registrations" }
  ActiveAdmin.routes(self)  

  match 'about' => 'info#about', :via => [:get]
  match 'privacy' => 'info#privacy', :via => [:get]
  match 'terms' => 'info#terms', :via => [:get]

  # The priority is based upon order of creation:
  # first created -> highest priority.

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
