Rails.application.routes.draw do
  # Add your extension routes here
  
  resources :sale_promotions do
    collection do
      get "all"
      get "new"
    end
  end
  resources :sale_on_sale_imports
end
