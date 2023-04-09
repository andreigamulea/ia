Rails.application.routes.draw do
  get 'admin/index'
  put 'admin/update/:id', to: 'admin#update', as: 'update_admin'
  get 'admin/edit/:id', to: 'admin#edit', as: 'edit_admin'

  resources :valorinutritionales, only: [:index] do
    collection do
      post :calculate
      post :select_valorinutritionales, path: 'select' # modificat aici
      post :reset_session_data, path: 'reset_session_data'
      post :delete_selected
      #get :search
    end
  end

  
  get 'home/index'
  get 'xlsxtopg/index'
  get 'gestionare_useri_cursuri/index'
  get '/gestionare_useri_cursuri/import_from_xlsx_cursantinutritie', to: 'gestionare_useri_cursuri#import_from_xlsx_cursantinutritie', as: 'import_from_xlsx_cursantinutritie_gestionare_useri_cursuri'
  get 'gestionare_useri_cursuri/stergecursntinutritie', to: 'gestionare_useri_cursuri#stergecursntinutritie', as: 'stergecursntinutritie_gestionare_useri_cursuri'
  get '/valorinutritionales/show_selected', to: 'valorinutritionales#show_selected', as: 'show_selected_valorinutritionales'
  get 'valorinutritionales/show_selected', to: 'valorinutritionales#show_selected', as: 'show_selected'  
  get 'valorinutritionales/index', format: :turbo_stream
  get 'valorinutritionales_table', to: 'valorinutritionales#valorinutritionales_table'
  get '/xlsxtopg/preluaredate', to: 'xlsxtopg#preluaredate', as: 'preluaredate_xlsxtopg'
  get '/xlsxtopg/preluaredate1', to: 'xlsxtopg#preluaredate1', as: 'preluaredate1_xlsxtopg'
  get '/xlsxtopg/preluaredate2', to: 'xlsxtopg#preluaredate2', as: 'preluaredate2_xlsxtopg'
  get '/xlsxtopg/preluaredate3', to: 'xlsxtopg#preluaredate3', as: 'preluaredate3_xlsxtopg'
  get '/xlsxtopg/preluaredate4', to: 'xlsxtopg#preluaredate4', as: 'preluaredate4_xlsxtopg'
  get '/xlsxtopg/preluaredate5', to: 'xlsxtopg#preluaredate5', as: 'preluaredate5_xlsxtopg'
  get '/xlsxtopg/preluaredate6', to: 'xlsxtopg#preluaredate6', as: 'preluaredate6_xlsxtopg'
  get '/xlsxtopg/preluaredate7', to: 'xlsxtopg#preluaredate7', as: 'preluaredate7_xlsxtopg'
  get '/xlsxtopg/preluaredate8', to: 'xlsxtopg#preluaredate8', as: 'preluaredate8_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari', to: 'xlsxtopg#sterge_inregistrari', as: 'sterge_inregistrari_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari1', to: 'xlsxtopg#sterge_inregistrari1', as: 'sterge_inregistrari1_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari2', to: 'xlsxtopg#sterge_inregistrari2', as: 'sterge_inregistrari2_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari3', to: 'xlsxtopg#sterge_inregistrari3', as: 'sterge_inregistrari3_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari4', to: 'xlsxtopg#sterge_inregistrari4', as: 'sterge_inregistrari4_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari5', to: 'xlsxtopg#sterge_inregistrari5', as: 'sterge_inregistrari5_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari6', to: 'xlsxtopg#sterge_inregistrari6', as: 'sterge_inregistrari6_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari7', to: 'xlsxtopg#sterge_inregistrari7', as: 'sterge_inregistrari7_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari8', to: 'xlsxtopg#sterge_inregistrari8', as: 'sterge_inregistrari8_xlsxtopg'
  get 'xlsxtopg/test'
  resources :valorinutritionales do
    collection do
      get 'pagination_turbo_stream'
    end
  end
  resources :valorinutritionales do
    collection do
      get 'pagination_turbo_stream'
      post 'process_selected'
    end
  end
  resources :valorinutritionales do
    get 'index_turbo_stream', on: :collection
    post 'selected_records', on: :collection
  end

 
  resources :listacursuris
  resources :cursuris
 get 'users/sign_out'
 #devise_for :users, skip: :all
  devise_for :users, controllers: {
    sessions: 'devise/sessions',
    registrations: 'devise/registrations',
    passwords: 'devise/passwords',
    confirmations: 'devise/confirmations',
    unlocks: 'devise/unlocks'
  }


  resources :valorinutritionales
  resources :srota
  resources :tipuri_props
  resources :importanta
  resources :listaproprietatis
  resources :recomandaris
  resources :plante_partis
  resources :plantes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end