Rails.application.routes.draw do
  # Add your extension routes here
  
  resources :sale_promotions
  resources :sale_on_sale_imports
  match '/new_sos' =>  "sale_promotions#new_sos" , :as => :new_sos 
end
