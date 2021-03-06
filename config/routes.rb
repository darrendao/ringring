Ringring::Application.routes.draw do


  resources :call_list_memberships


  resources :dashboard

  resources :phone_number_infos

  resources :phone_carriers

  resources :call_list_owners

  resources :call_lists do
    collection do 
      post 'add_call_escalation'
      get 'remove_call_escalation'
      get 'pull_oncalls_from_calendar'
      get 'oncall_email'
      get 'smart_contacts'
      get 'download_calendar'
      get 'mine'
      get 'members_vacations'
      get 'gen_oncall_assignments'
    end
    resources :oncall_assignments do
      collection do
        get 'events_for_cal'
        get 'refresh_listing'
      end
    end
    resources :oncall_times

    resources :call_escalations do
      collection do
        post 'sort'
      end
    end
    resources :call_list_memberships do
      collection do
        post 'sort'
      end
    end
    resources :smart_contact_lists
  end

  resources :roles
  resources :ecv
  resources :call_list_calendars do
    collection do
      get 'ical'
    end
  end

  devise_for :users

  resources :users do
    resources :vacations
  end

#  resources :call_escalations do
#    collection do 
#      post 'sort'
#    end
#  end

  resources :twilio_error_notifications do
    collection do
      post 'twilio_error_notifications'
    end
  end

  resources :twilio_call_escalations do
    collection do 
      get 'attempt_call'
      post 'attempt_call'
      post 'screen_for_machine'
      post 'complete_call'
      get 'call_list_menu'
      post 'gather_call_list_id'
      get 'gather_call_list_id'
    end
  end

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
  root :to => "dashboard#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
