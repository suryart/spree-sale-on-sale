Rails.application.routes.draw do
  # Add your extension routes here
  
  resources :sale_on_sales do
    collection do
      get "all"
    end
  end
  resources :sale_on_sale_imports
end
