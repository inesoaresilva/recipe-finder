Rails.application.routes.draw do
  root "recipes#index"

  if Rails.env.production?
    get "import/recipes", to: "import#recipes"
    get "/import/ingredient_count", to: "import#ingredient_count"
    get "/debug/duplicate-recipes", to: "debug#duplicate_recipes"
  end

  resources :recipes do
    collection do
      get "search"
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
