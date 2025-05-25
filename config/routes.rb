Rails.application.routes.draw do
  scope path: ApplicationResource.endpoint_namespace, defaults: { format: :jsonapi } do
    resources :authors, only: %i[index show]
    resources :categories, only: :index
    resources :recipes, only: %i[index show] do
      member do
        post "like", to: "recipes#like"
        post "unlike", to: "recipes#unlike"
        put "feature", to: "recipes#feature"
      end
      get "stats", to: "recipes#stats", on: :collection
    end

    mount VandalUi::Engine, at: '/vandal'
  end
end
