Beautymeets2::Application.routes.draw do

	resources :collections do

		#match ":id" => "collections#update", :constraints => { method: "PUT" }
		resources :pictures
	end

  resources :push_notifications do
  	member do 
  		get 'call_send'
  	end
  end


	resources :devices

	root :to => 'welcome#index'
	devise_for :admin_users, ActiveAdmin::Devise.config

	match "hello_pusher" => 'welcome#hello_pusher'

	# below two blocks should be defined before devise routes because of user/auth/:action/callback	                                                    
	resources :authentications
	# for kakao authentication, upper match path can't apply in kakao developer site, 
	# this came from omniauth-kakao 
	
	match '/users/auth/:provider/callback' => 'authentications#create'#, defaults: { format: :json }
	#match '/oauth/' => 'authentications#create' 

	# Let devise enabled trhough 'api' url not to change module in class definition
	devise_scope :user do
		match "api/v1/auth_providers/:provider" => "authentications#new", defaults: { format: :json }
		match "api/v1/auth/:id" => "authentications#show", defaults: { format: :json }
		match "api/v1/join" => "registrations#create", defaults: { format: :json }#, :constraints => { method: "POST" }#,  defaults: { format: :json }
		match "api/v1/login" => "sessions#create", defaults: { format: :json }#, :constraints => { method: "POST" }
		match "api/v1/logout" => "sessions#destroy", defaults: { format: :json }, :constraints => { method: "DELETE" }

		#match 'api/users/auth/:provider' => 'authentications#create', defaults: { format: :json }
		#match 'api/users/auth/:provider/callback' => 'authentications#create', defaults: { format: :json }
	end
	
	# Redirect Devise Routes
	devise_for :users, :path_names => { :sign_up => "join", :sign_in => "login", :sign_out => "logout", :edit_name => "edit_name", :edit_avatar => "edit_avatar", :edit_password => "edit_password" }, controllers: { registrations: "registrations", sessions: "sessions"}
	ActiveAdmin.routes(self)  
	
	# Set the default format to json
	namespace :api,  defaults: {format: :json} do 
		namespace :v1 do 

			match "authors" => "authors#index"
			match "authors/:id" => "authors#show"

			resources "events", defaults: { format: :json}

			match "devices" => "devices#create", defaults: { format: :json }
			match "me" => "users#index"

			match "notices" => "notices#index", :constraints => { method: "OPTIONS" }
			match "notices/:id" => "notices#show"#, :constraints => { method: "OPTIONS" }

			match "collections" => "collections#index", :constraints => { method: "OPTIONS" }
			match "collections/:id" => "collections#show"#, :constraints => { method: "GET" }

			match "posts" => "posts#index", :constraints => { method: "OPTIONS" }
			match "posts/:id" => "posts#show"#, :constraints => { method: "GET" }
			#match "posts/:id/toggleFavorite" => "posts#toggle_favorite", :constraints => { method: "POST" }

			match "users" => "users#index"#, :constraints => { method: "GET" }
			match "users/:id" => "users#show", :constraints => { method: "OPTIONS" }
			match "users/:id" => "users#update", :constraints => { method: "PUT" }
			match "users/:id/edit" => "users#edit"#, :constraints => { method: "GET" }
			match "users/:id/notifications" => "users#notifications"#, :constraints => { method: "GET" }
			match "users/:id/favorites" => "users#favorites"#, :constraints => { method: "GET" }

			resources :users, :notices, :boards

			resources :collections do
				resources :comments do 
					member do 
						get 'vote'
						get 'unvote'
					end
				end
				resources :posts
			end

			resources :posts do
				resources :comments do
					member do 
						get 'vote'
						get 'unvote'
					end
				end
				match "comments" => "comments#index", :constraints => { method: "OPTIONS" }
				match "comments" => "comments#create", :constraints => { method: "POST" }
				match "comments/:id" => "comments#show", :constraints => { method: "OPTIONS" }
				match "comments/:id" => "comments#destroy", :constraints => { method: "DELETE" }

				resources :bookmarks
				match "favorites" => "bookmarks#index", :constraints => { method: "OPTIONS" }
				match "favorites" => "bookmarks#create", :constraints => { method: "POST" }
			end

			resources :users do
				resources :profiles
				match "profiles" => "profiles#index", :constraints => { method: "OPTIONS" }
				match "profiles" => "profiles#update", :constraints => { method: "PUT" }
			end
		end
	end

	resources :channel_logs do 
		resources :channel_log_details  
		get :autocomplete_channel_name, on: :collection   
		get :update_log_details, on: :collection   
	end

	resources :notices do 
		resources :comments do
			member do 
				get 'vote'
				get 'unvote'
			end
		end
	end

	resources :events do
		resources :pictures
		resources :comments do
			member do 
				get 'vote'
				get 'unvote'
			end
		end
	end

	match 'notifications' => 'activities#index'

	resources :boards do 
		resources :pictures
		resources :comments do
			member do 
				get 'vote'
				get 'unvote'
			end
		end
	end

	resources :posts do 
		resources :pictures

		resources :collections do 
			match 'drop' => 'collections#drop_collecting', :via => [:delete]     
		end
		get :autocomplete_collection_title, :on => :collection   
		
		resources :comments do
			member do 
				get 'vote'
				get 'unvote'
			end
		end
	end

	get 'bookmarks/toggle', to: "bookmarks#toggle"


	resources :bookmarks

	get 'members/:id/tutorials', to: 'members#tutorials', as: :member_tutorials
	get 'members/:id/beautyclasses', to: 'members#beautyclasses', as: :member_beautyclasses
	get 'members/:id/bookmarks', to: 'members#bookmarks', as: :member_bookmarks
	get 'members/:id/notifications', to: 'members#notifications', as: :member_notifications

	get "activities/index"

	get "welcome/index"


	resources :checkouts

	resources :welcome
	match '/feed' => 'welcome#feed',
			:as => :feed,
			:defaults => { :format => 'atom' }

	resources :activities
	
	resources :user_steps

	resources :shops do
		resources :locations, :beautystars
	end

	resources :locations

	resources :members 

	resources :tutorials do 
		resources :channel_logs
		resources :pictures
		resources :comments do
			resources :picture
			member do 
				get 'vote'
				get 'unvote'
			end
		end
		resources :items do 
			match 'unitemize' => 'items#unitemize', :via => [:delete]     
			match 'featured' => 'items#featured', :via => [:get]     
			match 'unfeatured' => 'items#unfeatured', :via => [:get]     
		end
		get :autocomplete_item_name, :on => :collection   

		resources :collections do 
			match 'drop' => 'collections#drop_collecting', :via => [:delete]     
		end
		get :autocomplete_collection_title, :on => :collection   
		
		#match 'tutorials/:tutorial_id/items/:id/unitemize' => 'items#unitemize', :via => [:delete]
	end

	resources :beautyclasses do 
		resources :shops, :pictures, :locations, :checkouts

		resources :comments do
			member do 
				get 'vote'
				get 'unvote'
			end
		end
		get :autocomplete_location_name, :on => :collection   
	end

	resources :items do
		resources :pictures, :tutorials, :videos
		resources :comments do
			member do 
				get 'vote'
				get 'unvote'
			end
		end
		resources :collections do 
			match 'drop' => 'collections#drop_collecting', :via => [:delete]     
		end
		get :autocomplete_collection_title, :on => :collection   
		get :autocomplete_brand_name, :on => :collection  
		get :logs, :on => :collection   
	end

	get "pictures/index"
	get "pictures/new"

	resources :beautystars do 
		resources :pictures
		resources :comments do
			member do 
				get 'vote'
				get 'unvote'
			end
		end
	end


	get 'tags/:tag', to: 'info#tag', as: :tag

	resources :categories 
	
	resources :brands do
		resources :pictures
	end

	resources :companies

	resources :videos do 
		resources :items
		
		resources :collections do 
			match 'drop' => 'collections#drop_collecting', :via => [:delete]     
		end
		get :autocomplete_collection_title, :on => :collection   
		
		resources :comments do
			member do 
				get 'vote'
				get 'unvote'
			end
		end
	end

	resources :video_groups do 
		collection do 
			get :update_groups
		end
	end


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
