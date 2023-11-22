Rails.application.routes.draw do    
  resources :tipconstitutionals
  get 'evaluare_tipologie_ayurvedica', to: 'tipconstitutionals#evaluare_tipologie_ayurvedica'
  get 'calculate_totals', to: 'tipconstitutionals#process_totals'
  
  get 'test1', to: 'tipconstitutionals#test1'
  
  resources :modulecursuris
  get '/crypto_prices/show_crypto_price', to: 'crypto_prices#show_crypto_price', as: 'show_crypto_price'

  get 'tayt12/index'
  
  get 'tayt12/transport_international/:return_to', to: 'tayt12#transport_international', as: :tayt12_transport_international
  get 'video/link/:return_to', to: 'videos#linkocazional', as: 'video_link', defaults: { return_to: 'default' }



  get '/cursayurveda', to: 'cursuriayurvedas#cursayurveda'
  resources :cursuriayurvedas
  get 'nutritie1', to: 'nutritie1#index'
  get 'nutritie2', to: 'nutritie2#index'
  get 'nutritie3', to: 'nutritie3#index'
  get 'myvideo', to: 'videos#myvideo'
  get 'videos/:id/myvideo1', to: 'videos#myvideo1', as: 'myvideo1'
  get 'videos/:id/myvideo2', to: 'videos#myvideo2', as: 'myvideo2'
  get 'videos/:id/myvideo3', to: 'videos#myvideo3', as: 'myvideo3' 
  get 'videos/:id/myvideo4', to: 'videos#myvideo4', as: 'myvideo4' 
  get 'videos/:id/myvideo6', to: 'videos#myvideo6', as: 'myvideo6' 
  get 'videos/:id/myvideo7', to: 'videos#myvideo7', as: 'myvideo7'
  get 'videos/:id/myvideo8', to: 'videos#myvideo8', as: 'myvideo8'
  get 'videos/:id/myvideo9', to: 'videos#myvideo9', as: 'myvideo9'
 
  get 'videos/tayv2', to: 'videos#tayv2', as: 'tayv2'
  get 'tabara_de_ayurveda_toamna1', to: 'videos#tayt12', as: 'tayt12'
  get 'tabara_de_ayurveda_toamna2', to: 'videos#tayt122', as: 'tayt122'

  
  resources :videos
  get 'facturas/generate_pdf', to: 'facturas#generate_pdf', as: 'generate_pdf_facturas'
  #get 'facturas/download_all', to: 'facturas#download_all', defaults: { format: 'pdf' } 
  #get 'facturas/download_all', to: 'facturas#download_all', as: 'download_all_facturas'
  get 'facturas/download_all', to: 'facturas#download_all', as: 'download_all_facturas', defaults: { format: 'pdf' }  
  get 'facturas/download1', to: 'facturas#download1', as: 'download1_factura'
  get 'facturas/:id/download', to: 'facturas#download', as: 'download_factura'
  get 'facturicomenzi', to: 'facturas#facturicomenzi'
  get 'facturas/:id', to: 'facturas#show', format: 'pdf'
  


  resources :facturas, path: 'factura', except: :index
  get 'factura', to: 'facturas#index'
  
  



post '/stripe-webhooks', to: 'stripe_webhooks#create'


 get '/detaliifacturares/:id/pay', to: 'detaliifacturares#pay', as: 'detaliifacturare_pay'
 get 'detaliifacturares/:id/get_stripe_session_id', to: 'detaliifacturares#get_stripe_session_id', as: 'get_stripe_session_id'
 patch 'detaliifacturares/:id/update1', to: 'detaliifacturares#update1', as: 'detaliifacturare_update1'
 get 'detaliifacturares/:id/edit1', to: 'detaliifacturares#edit1', as: 'detaliifacturare_edit1'

  get 'prods/produscurent'
  

  get 'edit_comenziprod/:comanda_id', to: 'comandas#edit_comenziprod', as: :edit_comenziprod
  patch 'comandas/:id/update_comenziprod', to: 'comandas#update_comenziprod', as: :update_comenziprod
  get 'select_comanda_id', to: 'comandas#select_comanda_id'
  post 'select_edit_comenziprod', to: 'comandas#select_edit_comenziprod'

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
  get '/plata_nutritie3/export', to: 'paginisites#export_to_xlsx_plata_nutritie3', as: 'export_plata_nutritie3'
  get '/plata_tayv2/export', to: 'paginisites#export_to_xlsx_plata_tayv2', as: 'export_plata_tayv2'
  get '/plata_tayt12/export', to: 'paginisites#export_to_xlsx_plata_tayt12', as: 'export_plata_tayt12'
  get '/plata_an1/export', to: 'paginisites#export_to_xlsx_plata_an1', as: 'export_plata_an1'
  get '/plata_an1/summary_export', to: 'paginisites#export_to_xlsx_summary', as: 'export_to_xlsx_summary'

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
  

  get 'home/index1', to: 'home#index1'

  get 'home/index'
  get 'evaluare_tipologie_ayurvedica', to: 'home#evaluare_tipologie_ayurvedica'

  ##get 'home/listavegetalegratis', to: 'home#listavegetalegratis', as: :listavegetalegratis_home
  get 'home/listavegetalegratis/:acces', to: 'home#listavegetalegratis', as: :listavegetalegratis_home
  
  get 'home/userip', to: 'home#userip', as: 'userip'
  get 'cazuriparticulare', to: 'home#cazuriparticulare', as: 'cazuriparticulare'


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
  get '/xlsxtopg/preluaredate11', to: 'xlsxtopg#preluaredate11', as: 'preluaredate11_xlsxtopg'
  get '/xlsxtopg/preluaredate12', to: 'xlsxtopg#preluaredate12', as: 'preluaredate12_xlsxtopg'
  get '/xlsxtopg/preluaredate13', to: 'xlsxtopg#preluaredate13', as: 'preluaredate13_xlsxtopg'
  get '/xlsxtopg/preluaredate14', to: 'xlsxtopg#preluaredate14', as: 'preluaredate14_xlsxtopg'
  get '/xlsxtopg/preluaredate15', to: 'xlsxtopg#preluaredate15', as: 'preluaredate15_xlsxtopg'
  get '/xlsxtopg/preluaredate16', to: 'xlsxtopg#preluaredate16', as: 'preluaredate16_xlsxtopg'
  get '/xlsxtopg/preluaredate17', to: 'xlsxtopg#preluaredate17', as: 'preluaredate17_xlsxtopg'
  get '/xlsxtopg/preluaredate18', to: 'xlsxtopg#preluaredate18', as: 'preluaredate18_xlsxtopg'
  get '/xlsxtopg/preluaredate19', to: 'xlsxtopg#preluaredate19', as: 'preluaredate19_xlsxtopg'
  get '/xlsxtopg/preluaredate20', to: 'xlsxtopg#preluaredate20', as: 'preluaredate20_xlsxtopg'
  get '/xlsxtopg/preluaredate21', to: 'xlsxtopg#preluaredate21', as: 'preluaredate21_xlsxtopg'
  get '/xlsxtopg/preluaredate22', to: 'xlsxtopg#preluaredate22', as: 'preluaredate22_xlsxtopg'
  get '/xlsxtopg/preluaredate23', to: 'xlsxtopg#preluaredate23', as: 'preluaredate23_xlsxtopg'

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
    sessions: 'authentication',  # controler de sesiuni
    #registrations: 'devise/registrations',    
    
    registrations: 'custom_registrations',
        
    passwords: 'custom_passwords',
    confirmations: 'devise/confirmations',
    #omniauth_callbacks: 'users/omniauth_callbacks',
    omniauth_callbacks: 'omniauth_callbacks',
    unlocks: 'devise/unlocks'   
  }
  devise_scope :user do
    get 'users/sign_in/:return_to', to: 'devise/sessions#new', as: :new_user_session_with_return #face ruta frumoasa la login
    get 'users/sign_up/:return_to', to: 'devise/registrations#new', as: :new_user_registration_with_return
    get "/users/sign_out" => "devise/sessions#destroy"

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