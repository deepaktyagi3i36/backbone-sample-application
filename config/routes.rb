TestPr::Application.routes.draw do
  
  # person resource
  # index, create, bulk_upload
  resources :persons, only: [:index, :create] do 
    collection do
      post :bulk_upload
    end
  end
end
