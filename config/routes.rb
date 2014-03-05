LocalSupport::Application.routes.draw do

  devise_for :users

  get 'contributors' => 'contributors#show'
  match 'organizations/search' => 'organizations#search'

  get '/organization_reports/without_users' => 'organization_reports#without_users_index', as: :organizations_report
  post '/invitations' => 'invitations#create', as: :invitations

  get '/user_reports/all' => 'user_reports#index', as: :users_report
  put '/user_reports/update' => 'user_reports#update', as: :user_report

  resources :pages
  resources :organizations

  # so that static pages are linked directly instead of via /pages/:id
  get ':id', to: 'pages#show', as: :page
  put ':id', to: 'pages#update', as: :page
  delete ':id', to: 'pages#destroy', as: :page

  post 'cookies/allow', to: 'application#allow_cookie_policy'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  # match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  # resources :products

  # Sample resource route with options:
  # resources :products do
  # member do
  # get 'short'
  # post 'toggle'
  # end
  #
  # collection do
  # get 'sold'
  # end
  # end

  # Sample resource route with sub-resources:
  # resources :products do
  # resources :comments, :sales
  # resource :seller
  # end

  # Sample resource route with more complex sub-resources
  # resources :products do
  # resources :comments
  # resources :sales do
  # get 'recent', :on => :collection
  # end
  # end

  # Sample resource route within a namespace:
  # namespace :admin do
  # # Directs /admin/products/* to Admin::ProductsController
  # # (app/controllers/admin/products_controller.rb)
  # resources :products
  # end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'organizations#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
