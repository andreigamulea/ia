Rails.application.routes.draw do
  resources :videos
  resources :facturas
get 'facturas/:id/download', to: 'facturas#download', as: 'download_factura'
get 'facturas/:id', to: 'facturas#show', format: 'pdf'

post '/stripe-webhooks', to: 'stripe_webhooks#create'


 get '/detaliifacturares/:id/pay', to: 'detaliifacturares#pay', as: 'detaliifacturare_pay'
 get 'detaliifacturares/:id/get_stripe_session_id', to: 'detaliifacturares#get_stripe_session_id', as: 'get_stripe_session_id'
 patch 'detaliifacturares/:id/update1', to: 'detaliifacturares#update1', as: 'detaliifacturare_update1'
 get 'detaliifacturares/:id/edit1', to: 'detaliifacturares#edit1', as: 'detaliifacturare_edit1'

  get 'prods/produscurent'
  
  resources :prods
  resources :comandas
  
  #post 'detaliifacturares/create'
  mount Ahoy::Engine => "/ahoy"
  resources :lista_vegetales
  resources :paginisites
  get 'userilogati', to: 'paginisites#userilogati'
  get '/useriunici_logati', to: 'paginisites#useriunici_logati', as: 'useriunici_logati_paginisites'
  get '/useriunici_logati/export', to: 'paginisites#export_to_xlsx', as: 'export_useriunici_logati'
  get '/useriunici_nelogati/export', to: 'paginisites#export_to_xlsx_no_login', as: 'export_useriunici_nelogati'

  get '/paginisites/:id/statistici_utilizator', to: 'paginisites#statistici_utilizator', as: 'statistici_utilizator_paginisite'
  resources :statistics, only: [:index]
  
  get 'authentication/login'
  get 'admin/index'
  put 'admin/update/:id', to: 'admin#update', as: 'update_admin'
  get 'admin/edit/:id', to: 'admin#edit', as: 'edit_admin'
  get 'admin/new', to: 'admin#new', as: 'new_admin'
  
 # în routes.rb
 
  get 'detaliifacturare', to: 'detaliifacturares#datefacturare', as: 'datefacturare'  
  resources :detaliifacturares, only: [:index, :edit, :create, :update, :datefacturare, :show]
  
  
  


  post 'admin/create', to: 'admin#create', as: 'create_admin'
  

  
  

  resources :valorinutritionales, only: [:index], path: 'valori-nutritionale' do
    collection do
      post :calculate
      post :select_valorinutritionales, path: 'select'
      post :reset_session_data, path: 'reset_session_data'
      post :delete_selected
      get :show_selected
      get :valorinutritionales_table
      get :index_turbo_stream
      post :selected_records
      get :pagination_turbo_stream
      post :process_selected
      post :track
    end
  end
  

  
  get 'home/index'
  #get 'home/listavegetalegratis', to: 'home#listavegetalegratis', as: :listavegetalegratis_home
  get 'home/listavegetalegratis/:acces', to: 'home#listavegetalegratis', as: :listavegetalegratis_home
  
  get 'home/mergi/:mesaj', to: 'home#mergi', as: 'home_mergi'


  get 'successtripe', to: 'home#successtripe', as: 'successtripe'
  get 'home/cookiestest', to: 'home#cookiestest'
  get '/termeni-conditii', to: 'home#termeni_conditii'
  get '/politica-confidentialitate', to: 'home#politica_confidentialitate'
  get '/politica-cookies', to: 'home#politica_cookies'
  get '/politica-gdpr', to: 'home#politica_gdpr'
  get '/servicii', to: 'home#servicii'
  get '/resetareparola', to: 'home#resetareparola'
  get '/panouadmin', to: 'home#panouadmin'
  get '/tabeleahoy', to: 'home#tabeleahoy', as: 'tabeleahoy_home'

  get '/contact', to: 'home#contact'
  post '/contact', to: 'home#contact'
  get 'xlsxtopg/index'
  get 'gestionare_useri_cursuri/index'
  get '/gestionare_useri_cursuri/import_from_xlsx_cursantinutritie', to: 'gestionare_useri_cursuri#import_from_xlsx_cursantinutritie', as: 'import_from_xlsx_cursantinutritie_gestionare_useri_cursuri'
  get 'gestionare_useri_cursuri/stergecursntinutritie', to: 'gestionare_useri_cursuri#stergecursntinutritie', as: 'stergecursntinutritie_gestionare_useri_cursuri'
 
  get '/xlsxtopg/preluaredate', to: 'xlsxtopg#preluaredate', as: 'preluaredate_xlsxtopg'
  get '/xlsxtopg/preluaredate1', to: 'xlsxtopg#preluaredate1', as: 'preluaredate1_xlsxtopg'
  get '/xlsxtopg/preluaredate2', to: 'xlsxtopg#preluaredate2', as: 'preluaredate2_xlsxtopg'
  get '/xlsxtopg/preluaredate3', to: 'xlsxtopg#preluaredate3', as: 'preluaredate3_xlsxtopg'
  get '/xlsxtopg/preluaredate4', to: 'xlsxtopg#preluaredate4', as: 'preluaredate4_xlsxtopg'
  get '/xlsxtopg/preluaredate5', to: 'xlsxtopg#preluaredate5', as: 'preluaredate5_xlsxtopg'
  get '/xlsxtopg/preluaredate6', to: 'xlsxtopg#preluaredate6', as: 'preluaredate6_xlsxtopg'
  get '/xlsxtopg/preluaredate7', to: 'xlsxtopg#preluaredate7', as: 'preluaredate7_xlsxtopg'
  get '/xlsxtopg/preluaredate8', to: 'xlsxtopg#preluaredate8', as: 'preluaredate8_xlsxtopg'
  get '/xlsxtopg/preluaredate9', to: 'xlsxtopg#preluaredate9', as: 'preluaredate9_xlsxtopg'
  get '/xlsxtopg/preluaredate10', to: 'xlsxtopg#preluaredate10', as: 'preluaredate10_xlsxtopg'

  get 'xlsxtopg/sterge_inregistrari', to: 'xlsxtopg#sterge_inregistrari', as: 'sterge_inregistrari_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari1', to: 'xlsxtopg#sterge_inregistrari1', as: 'sterge_inregistrari1_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari2', to: 'xlsxtopg#sterge_inregistrari2', as: 'sterge_inregistrari2_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari3', to: 'xlsxtopg#sterge_inregistrari3', as: 'sterge_inregistrari3_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari4', to: 'xlsxtopg#sterge_inregistrari4', as: 'sterge_inregistrari4_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari5', to: 'xlsxtopg#sterge_inregistrari5', as: 'sterge_inregistrari5_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari6', to: 'xlsxtopg#sterge_inregistrari6', as: 'sterge_inregistrari6_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari7', to: 'xlsxtopg#sterge_inregistrari7', as: 'sterge_inregistrari7_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari8', to: 'xlsxtopg#sterge_inregistrari8', as: 'sterge_inregistrari8_xlsxtopg'
  get 'xlsxtopg/sterge_inregistrari10', to: 'xlsxtopg#sterge_inregistrari10', as: 'sterge_inregistrari10_xlsxtopg'

  get 'xlsxtopg/test'
 
  

 
  resources :listacursuris
  resources :cursuris
 
 #devise_for :users, skip: :all
  devise_for :users, controllers: {
    sessions: 'authentication',  # aici se schimba
    registrations: 'devise/registrations',
    #passwords: 'devise/passwords',
    #sessions: 'sessions',
    passwords: 'custom_passwords',
    confirmations: 'devise/confirmations',
    unlocks: 'devise/unlocks'   
  }
  devise_scope :user do
    get 'users/sign_in/:return_to', to: 'devise/sessions#new', as: :new_user_session_with_return #face ruta frumoasa la login
  end
 
  # config/routes.rb
  resources :users, only: [] do
    member do
      put :set_inactive
    end
  end

  
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
  #devise_scope :user do
    #root to: "devise/sessions#new"
  #end
end