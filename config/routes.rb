Hzqg::Application.routes.draw do

  get "home/index"
  root 'home#index'

  resources :sessions, :only => [:new, :create, :destroy]
  resources :users
  resources :products do
    member do
      get :edit_units
      get :edit_sub_products
      get :get_units
    end
  end
  resources :warehouses do
    member do
      get :edit_alert_count
      patch :update_alert_count
    end
  end
  resources :purchases
  resources :orders do
    member do
      get :new_ration
      post :create_ration
      get :rations

      get :new_shipment
      post :create_shipment
      get :shipments
    end
  end
  resources :notifications do
    collection do
      get :update_count
    end
    member do
      get :read
    end
  end
  
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
