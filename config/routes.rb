Rails.application.routes.draw do 
  get 'xml/animaplant_api', to: 'xml#animaplant_api'
  get 'xml/animaplant_api', to: 'xml#animaplant_api', as: :animaplant_api

  get 'xml/animaplant', to: 'xml#animaplant'
  get "set_language", to: "language#set"


  get '/autocomplete_tara', to: 'detaliifacturares#autocomplete_tara'
  get '/autocomplete_judet', to: 'detaliifacturares#autocomplete_judet'
  get '/autocomplete_localitate', to: 'detaliifacturares#autocomplete_localitate'
  get '/autocomplete_tara2', to: 'date_facturares#autocomplete_tara'
  get '/autocomplete_judet2', to: 'date_facturares#autocomplete_judet'
  get '/autocomplete_localitate2', to: 'date_facturares#autocomplete_localitate'




  get 'cursuri_ayurveda/ayurveda_padartha', to: 'cursuri_ayurveda#ayurveda_padartha', as: 'ayurveda_padartha'
  get 'cursuri_ayurveda/export_to_xlsx_plata_ayurveda_padartha', to: 'cursuri_ayurveda#export_to_xlsx_plata_ayurveda_padartha', as: 'export_xlsx_plata_ayurveda_padartha'


  get 'rasayana/modul1', to: 'rasayana#modul1', as: 'rasayana_modul1'
  get 'rasayana/seminarii', to: 'rasayana#seminarii_rasayana', as: 'rasayana_seminarii'


  post 'home/make_unlisted', to: 'home#make_unlisted'
  get 'get_encryption_key', to: 'home#get_encryption_key'
  get 'priority_flag', to: 'application#priority_flag'  ##este  metoda get_encryption_key sub alta denumire
  get 'proxy_video', to: 'home#proxy_video'
  get '/generate_session_token', to: 'application#generate_session_token'
  
  
  resources :localitatis do
    collection do
      post 'import_judete'
      post 'import_tari'
      post 'import_localitati'
    end
  end
  get 'tabere/export_to_xlsx', to: 'tabere#export_to_xlsx_plata_tayv24', as: 'export_tayv24_xlsx'
  get 'tabere/export_to_xlsx_plata_tayt24', to: 'tabere#export_to_xlsx_plata_tayt24'
  get 'tabere/tayv24', to: 'tabere#tayv24', as: 'tayv24'
  get 'tabere/tayt24', to: 'tabere#tayt24', as: 'tayt24'
  get 'facturas/raport_accesare_facturi', to: 'facturas#raport_accesare_facturi', as: 'raport_accesare_facturi'
 
  get 'facturaproformas/facturi_xml_ayusgrup', to: 'facturaproformas#facturi_xml_ayusgrup', as: 'facturi_xml_ayusgrup'
  get 'facturaproformas/:id/download_xml_ayusgrup', to: 'facturaproformas#download_xml_ayusgrup', as: 'download_xml_ayusgrup'
  get 'facturaproformas/facturi_xml_lunar', to: 'facturaproformas#facturi_xml_lunar', as: 'facturi_xml_lunar'



  resources :facturaproformas do
    collection do
      get :generare_facturi
      post :creareproforma
      get 'facturaproformas/not_in_users', to: 'facturaproformas#not_in_users', as: 'not_in_users_facturaproformas'
      get :not_in_users, to: 'facturaproformas#not_in_users', as: 'not_in_users'
      get :situatii_lunare
      get :analiza_lunara
      get :download_analiza_lunara
      
    end
  
    member do
      get :download1, to: 'facturaproformas#download1', as: 'download1'
      get :download, to: 'facturaproformas#download', as: 'download'
      post :create_stripe_session
    end
  end
  
  
  
  
  
  get 'cancelstripe', to: 'home#cancelstripe', as: 'cancelstripe'
  

  resources :firmeproformas
  resources :an32324s do
    collection do
      get 'preluarean3'
    end
  end

  resources :firmas
  

  resources :date_facturares
  get 'export_datefacturare', to: 'date_facturares#export_datefacturare', as: :export_datefacturare
  
 # Rute personalizate care au prioritate
 get 'tvs/canal1', to: 'tvs#canal1'
 get 'tvs/canal2', to: 'tvs#canal2'
 get 'tvs/canal3', to: 'tvs#canal3'
 get 'tvs/rasayana1', to: 'tvs#rasayana1' #rasayana1
 get 'tvs/ayurveda_padartha', to: 'tvs#ayurveda_padartha' #ayurveda_padartha
 get 'tvs/reprogramare_curs', to: 'tvs#reprogramare_curs' #reprogramari video-uri -Thalia
 get 'tvs/seminarii', to: 'tvs#seminarii'

  

 get 'tvs/listacanal1', to: 'tvs#listacanal1', as: 'listacanal1'
 get 'tvs/listacanal2', to: 'tvs#listacanal2', as: 'listacanal2'
 get 'tvs/listacanal3', to: 'tvs#listacanal3', as: 'listacanal3'

 ### Rutele CRUD standard pentru tvs, inclusiv show
 
 resources :tvs
resources :listacanal2s
patch 'listacanal2s/:id', to: 'listacanal2s#update', as: :update_listacanal2
resources :listacanal3s
patch 'listacanal3s/:id', to: 'listacanal3s#update', as: :update_listacanal3

 

  get '/show_cerere_voluntar/:id', to: 'contractes#show_cerere_voluntar', as: 'show_cerere_voluntar'
  get '/show_gdpr_voluntar/:id', to: 'contractes#show_gdpr_voluntar', as: 'show_gdpr_voluntar'
  get '/show_contract_voluntar/:id', to: 'contractes#show_contract_voluntar', as: 'show_contract_voluntar'
  get '/show_fisa_postului_voluntar/:id', to: 'contractes#show_fisa_postului_voluntar', as: 'show_fisa_postului_voluntar'
  get 'test_wasabi_access', to: 'home#test_wasabi_access'
  get 'home/test_debian', to: 'home#test_debian'


  get 'test_ssl_connection', to: 'home#test_ssl_connection'
  get 'get_new_presigned_url', to: 'home#get_new_presigned_url'
  get 'get_presigned_url', to: 'home#get_presigned_url'
  get 'generate_presigned_key_url', to: 'home#generate_presigned_key_url'

  get 'home/test', to: 'home#test'
  get 'show_ip', to: 'home#show_ip'


  post '/newsletter', to: 'home#newsletter'
  get 'home/lista_newsletter', to: 'home#lista_newsletter', as: 'lista_newsletter'

  get 'admin/users/export', to: 'admin#export_users_to_xlsx', as: 'export_admin_users'
  get 'home/newsletters/export', to: 'home#export_newsletter_subscribers', as: 'export_newsletter_subscribers'



  get 'vajikarana/modul1', to: 'vajikarana#modul1', as: 'vajikarana_modul1'
  get 'vajikarana/modul2', to: 'vajikarana#modul2', as: 'vajikarana_modul2'
  #get 'vajikarana/download/:linkzip', to: 'vajikarana#download', as: 'vajikarana_download'
  get 'vajikarana/download/*linkzip', to: 'vajikarana#download', as: 'vajikarana_download', format: false
  get 'vajikarana/download2/*linkzip', to: 'vajikarana#download2', as: 'vajikarana_download2', format: false  

  get 'traditia_ayurvedica/amnaya', to: 'traditia_ayurvedica#amnaya', as: 'amnaya'
  get 'traditia_ayurvedica/jivaka', to: 'traditia_ayurvedica#jivaka', as: 'jivaka'
  get 'traditia_ayurvedica/asita', to: 'traditia_ayurvedica#asita', as: 'asita'
  get 'traditia_ayurvedica/jamadagni', to: 'traditia_ayurvedica#jamadagni', as: 'jamadagni'
  get 'traditia_ayurvedica/hiranyaksha', to: 'traditia_ayurvedica#hiranyaksha', as: 'hiranyaksha'
  get 'traditia_ayurvedica/sharaloma', to: 'traditia_ayurvedica#sharaloma', as: 'sharaloma'
  get 'traditia_ayurvedica/saunaka', to: 'traditia_ayurvedica#saunaka', as: 'saunaka'
  get 'traditia_ayurvedica/maudgalya', to: 'traditia_ayurvedica#maudgalya', as: 'maudgalya'
  get 'traditia_ayurvedica/cognitronica', to: 'traditia_ayurvedica#cognitronica', as: 'cognitronica'
  get 'traditia_ayurvedica/nimi', to: 'traditia_ayurvedica#nimi' , as: 'nimi'
  get 'traditia_ayurvedica/shukracharya', to: 'traditia_ayurvedica#shukracharya' , as: 'shukracharya'
  get 'traditia_ayurvedica/modele_spirituale', to: 'traditia_ayurvedica#modele_spirituale'


  #get 'traditia_ayurvedica/performanta_cognitiva', to: 'traditia_ayurvedica#performanta_cognitiva', as: 'performanta_cognitiva'
  # Definirea rutei cu un nume personalizat pentru helper-ul de cale
  get 'traditia_ayurvedica/optimizarea_performantelor_cognitive', to: 'traditia_ayurvedica#performanta_cognitiva', as: 'optimizarea_performantelor_cognitive'

  # ...alte rute...
  get 'nutritie4/index'
  get 'nutritie4/export_to_xlsx', to: 'nutritie4#export_to_xlsx_plata_nutritie4', as: 'export_nutritie4_xlsx'
  
  get 'contract/contract_voluntar', to: 'contractes#semneaza_contract', as: 'contract_voluntar'
  get 'contract/contract_voluntar1', to: 'contractes#semneaza_contract1', as: 'contract_voluntar1'

  post '/contractes', to: 'contractes#create', as: 'contractes_create' # Aici, 'contractes_create' este numele rutei
  #get 'contractes/vizualizeaza/:id', to: 'contractes#vizualizeaza_contract', as: 'contracte_vizualizeaza'
  get 'contractes/:id/vizualizeaza', to: 'contractes#vizualizeaza_contract', as: 'vizualizeaza_contract_contracte'
  get 'contractes/all', to: 'contractes#contracte_all', as: 'contracte_all'
  get 'contracte_useri/:id/show_pdf', to: 'contractes#show_pdf', as: 'contract_pdf'
  get 'contractes/preluare_emailuri', to: 'contractes#preluare_emailuri_din_text'

 
  get 'vizualizeaza_contract', to: 'contractes#vizualizeaza_contract', as: 'contractes_vizualizeaza_contract'
  get '/voluntariat', to: 'contractes#voluntariat', as: 'voluntariat'
  get '/voluntar', to: 'contractes#voluntar', as: 'voluntar' 
  get '/cerere_voluntar', to: 'contractes#cerere_voluntar', as: 'cerere_voluntar'
  
  get '/cerere_voluntar1', to: 'contractes#cerere_voluntar1', as: 'cerere_voluntar1'
  get '/gdpr', to: 'contractes#gdpr', as: 'gdpr' #pentru voluntari
  get '/gdpr1', to: 'contractes#gdpr1', as: 'gdpr1' #pentru contractori

  get '/ssm', to: 'contractes#ssm', as: 'ssm' #pentru voluntari
  get '/isu', to: 'contractes#isu', as: 'isu' #pentru voluntari

  get '/fisa_postului', to: 'contractes#fisa_postului', as: 'fisa_postului'
  get '/fisa_postului1', to: 'contractes#fisa_postului1', as: 'fisa_postului1'

  delete 'contractes/:id/destroy_contracte_useri', to: 'contractes#destroy_contracte_useri', as: 'destroy_contracte_useri'
  post 'verifica_cod', to: 'contractes#verifica_cod'
  
  resources :contractes do
    member do
      get 'view_contracte_useri', to: 'contractes#view_contracte_useri'
      get 'edit_contracte_useri', to: 'contractes#edit_contracte_useri'
      post :create_or_update_contracte_useri
      match 'create_or_update_contracte_useri', to: 'contractes#create_or_update_contracte_useri', via: [:post, :patch]
      post 'salveaza_gdpr', to: 'contractes#salveaza_gdpr'
      post 'salveaza_ssm', to: 'contractes#salveaza_ssm'
      post 'salveaza_isu', to: 'contractes#salveaza_isu'
      post 'salveaza_contract', to: 'contractes#salveaza_contract'
      post 'salveaza_fisa_postului', to: 'contractes#salveaza_fisa_postului'

    end
  end
  

  resources :tipconstitutionals
  get 'evaluare_tipologie_ayurvedica', to: 'tipconstitutionals#evaluare_tipologie_ayurvedica'
  get 'calculate_totals', to: 'tipconstitutionals#process_totals'
  
  get 'test1', to: 'tipconstitutionals#test1'
  
  resources :modulecursuris
  get '/crypto_prices/show_crypto_price', to: 'crypto_prices#show_crypto_price', as: 'show_crypto_price'

  get 'tayt12/index'
  
  get 'tayt12/transport_international/:return_to', to: 'tayt12#transport_international', as: :tayt12_transport_international
  get 'video/link/:return_to', to: 'videos#linkocazional', as: 'video_link', defaults: { return_to: 'default' }



  get '/an2', to: 'cursuriayurvedas#cursayurveda'
  get '/cursayurveda2425', to: 'cursuriayurvedas#cursayurveda2425'
  
  get '/an3', to: 'cursuriayurvedas#an2'
  get '/an4', to: 'cursuriayurvedas#an3'
  get '/an', to: 'cursuriayurvedas#an'

  resources :cursuriayurvedas
  get 'nutritie1', to: 'nutritie1#index'
  get 'nutritie', to: 'nutritie1#nutritie'
  get 'nutritie2', to: 'nutritie2#index'
  get 'nutritie3', to: 'nutritie3#index'
  get 'nutritie4', to: 'nutritie4#index'
  get 'myvideo', to: 'videos#myvideo'
  get 'videos/:id/myvideo1', to: 'videos#myvideo1', as: 'myvideo1'
  get 'videos/:id/myvideo2', to: 'videos#myvideo2', as: 'myvideo2'
  get 'videos/:id/myvideo3', to: 'videos#myvideo3', as: 'myvideo3' 
  get 'videos/:id/myvideo4', to: 'videos#myvideo4', as: 'myvideo4' 
  get 'videos/:id/myvideo44', to: 'videos#myvideo44', as: 'myvideo44'
  get 'videos/:id/myvideo444', to: 'videos#myvideo444', as: 'myvideo444'
  get 'videos/:id/myvideo6', to: 'videos#myvideo6', as: 'myvideo6' 
  get 'videos/:id/myvideo67', to: 'videos#myvideo67', as: 'myvideo67'
  get 'videos/:id/myvideo7', to: 'videos#myvideo7', as: 'myvideo7'
  get 'videos/:id/myvideo8', to: 'videos#myvideo8', as: 'myvideo8'
  get 'videos/:id/myvideo9', to: 'videos#myvideo9', as: 'myvideo9'
  get 'videos/:id/myvideo10', to: 'videos#myvideo10', as: 'myvideo10'
  get 'videos/:id/myvideo11', to: 'videos#myvideo11', as: 'myvideo11'
  get 'videos/:id/myvideo12', to: 'videos#myvideo12', as: 'myvideo12'
  get 'videos/:id/myvideo122', to: 'videos#myvideo122', as: 'myvideo122'
  get 'videos/:id/myvideo13', to: 'videos#myvideo13', as: 'myvideo13'
  get 'videos/:id/myvideo133', to: 'videos#myvideo133', as: 'myvideo133'
  get 'videos/:id/myvideo14', to: 'videos#myvideo14', as: 'myvideo14'
  get 'videos/:id/myvideo144', to: 'videos#myvideo144', as: 'myvideo144'
  get 'videos/:id/myvideo15', to: 'videos#myvideo15', as: 'myvideo15'
  get 'videos/:id/myvideo16', to: 'videos#myvideo16', as: 'myvideo16'
  get 'videos/:id/myvideo17', to: 'videos#myvideo17', as: 'myvideo17'
  get 'videos/:id/myvideo18', to: 'videos#myvideo18', as: 'myvideo18'
  get 'videos/:id/myvideo19', to: 'videos#myvideo19', as: 'myvideo19'
  get 'videos/:id/myvideo20', to: 'videos#myvideo20', as: 'myvideo20'
  get 'videos/:id/myvideo21', to: 'videos#myvideo21', as: 'myvideo21'
  get 'videos/:id/myvideo22', to: 'videos#myvideo22', as: 'myvideo22'
  get 'videos/:id/myvideo23', to: 'videos#myvideo23', as: 'myvideo23'
  get 'videos/:id/myvideo24', to: 'videos#myvideo24', as: 'myvideo24'
  get 'videos/:id/myvideo25', to: 'videos#myvideo25', as: 'myvideo25'
  get 'videos/:id/myvideo26', to: 'videos#myvideo26', as: 'myvideo26'
  get 'videos/:id/myvideo27', to: 'videos#myvideo27', as: 'myvideo27'
  get 'videos/tayv2', to: 'videos#tayv2', as: 'tayv2'
  get 'tabara_de_ayurveda_toamna1', to: 'videos#tayt12', as: 'tayt12'
  get 'tabara_de_ayurveda_toamna2', to: 'videos#tayt122', as: 'tayt122'

  
  resources :videos
  get 'facturas/facturi_xml', to: 'facturas#facturi_xml', as: 'facturi_xml'#pt xml
  get 'facturas/:id/download_xml', to: 'facturas#download_xml', as: 'download_xml_factura' #pt xml
  get 'facturas/:id/download_xml_company', to: 'facturas#download_xml_company', as: 'download_xml_company_factura'
  get 'facturas/:id/download_xml_individual', to: 'facturas#download_xml_individual', as: 'download_xml_individual_factura'

  get 'facturas/download_zip', to: 'facturas#download_all_xml', as: 'facturas_download_zip'
  


  get 'facturas/facturi_xml_ayushcell', to: 'facturas#facturi_xml_ayushcell', as: 'facturi_xml_ayushcell'#pt xml
  # Root route
  get 'facturas/generate_pdf', to: 'facturas#generate_pdf', as: 'generate_pdf_facturas'
  #get 'facturas/download_all', to: 'facturas#download_all', defaults: { format: 'pdf' } 
  #get 'facturas/download_all', to: 'facturas#download_all', as: 'download_all_facturas'
  get 'facturas/download_all', to: 'facturas#download_all', as: 'download_all_facturas', defaults: { format: 'pdf' } 
  get 'facturas/download_all_xml', to: 'facturas#download_all_xml', as: 'download_all_facturas_xml', defaults: { format: 'xml' }
 
  get 'facturas/download1', to: 'facturas#download1', as: 'download1_factura'
  get 'facturas/:id/download', to: 'facturas#download', as: 'download_factura'
  get 'facturicomenzi', to: 'facturas#facturicomenzi'
  get 'facturas/:id', to: 'facturas#show', format: 'pdf'
  


  resources :facturas, path: 'factura', except: :index
  get 'factura', to: 'facturas#index'
  
  


# config/routes.rb
post '/stripe_webhooks', to: 'stripe_webhooks_controller#payment_success' #ruta pt trimis notificare (email) cand am factura noua
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
  get 'comandas/index11', to: 'comandas#index11', as: :index11_comandas
  get 'comandas/new11', to: 'comandas#new11', as: :new11_comandas
  post 'comandas/create11', to: 'comandas#create11', as: :create11_comandas

  # Configurația unificată pentru resources :comandas
  resources :comandas do
    collection do
      # Poti adauga aici alte rute de tip collection dacă este necesar
    end
    member do
      
      patch 'update11', to: 'comandas#update11'
      get 'edit11', to: 'comandas#edit11', as: :edit11_comanda
      
      delete 'destroy11', to: 'comandas#destroy11', as: :destroy11_comanda
    end
  end
  
 
  
  #post 'detaliifacturares/create'
  mount Ahoy::Engine => "/ahoy"
  resources :lista_vegetales
  resources :paginisites
  get 'userilogati', to: 'paginisites#userilogati'
  get '/useriunici_logati', to: 'paginisites#useriunici_logati', as: 'useriunici_logati_paginisites'
  get '/useriunici_logati/export', to: 'paginisites#export_to_xlsx', as: 'export_useriunici_logati'
  get '/useriunici_nelogati/export', to: 'paginisites#export_to_xlsx_no_login', as: 'export_useriunici_nelogati'
  get '/plata_nutritie3/export', to: 'paginisites#export_to_xlsx_plata_nutritie3', as: 'export_plata_nutritie3'
  get '/plata_amnaya/export', to: 'paginisites#export_to_xlsx_plata_amnaya', as: 'export_plata_amnaya'
  get '/plata_vajikarana_modul1/export', to: 'paginisites#export_to_xlsx_plata_vajikarana_modul1', as: 'export_to_xlsx_plata_vajikarana_modul1'
  get '/plata_vajikarana_modul2/export', to: 'paginisites#export_to_xlsx_plata_vajikarana_modul2', as: 'export_to_xlsx_plata_vajikarana_modul2'
  get '/plata_tayv2/export', to: 'paginisites#export_to_xlsx_plata_tayv2', as: 'export_plata_tayv2'
  get '/plata_tayt12/export', to: 'paginisites#export_to_xlsx_plata_tayt12', as: 'export_plata_tayt12'
  get '/export_to_xlsx_plata_sesiunevara/export', to: 'paginisites#export_to_xlsx_plata_sesiunevara', as: 'export_to_xlsx_plata_sesiunevara'
  
  get 'export_plata_rasayana_modul1', to: 'paginisites#export_to_xlsx_plata_rasayana_modul1'

  
  get '/plata_an1/export', to: 'paginisites#export_to_xlsx_plata_an1', as: 'export_plata_an1'
  get '/plata_an1/summary_export', to: 'paginisites#export_to_xlsx_summary', as: 'export_to_xlsx_summary'
  get '/plata_an1/summary_export_2024_2025', to: 'paginisites#export_to_xlsx_summary_2024_2025', as: 'export_to_xlsx_summary_2024_2025'


  get '/plata_an1_2024_2025/export', to: 'paginisites#export_to_xlsx_plata_an1_2024_2025', as: 'export_plata_an1_2024_2025'


  get '/paginisites/:id/statistici_utilizator', to: 'paginisites#statistici_utilizator', as: 'statistici_utilizator_paginisite'
  get 'export_plata_an2_2425', to: 'paginisites#export_to_xlsx_plata_an2_2425' #an 2 2425 dupa comanda_id
  get 'export_to_xlsx_plata_generala_curs1', to: 'paginisites#export_to_xlsx_plata_generala_curs1'
  
  
  resources :statistics, only: [:index]
  
  get 'authentication/login'
  get 'admin/index'
  put 'admin/update/:id', to: 'admin#update', as: 'update_admin'
  get 'admin/edit/:id', to: 'admin#edit', as: 'edit_admin'
  get 'admin/new', to: 'admin#new', as: 'new_admin'
  
  
 # în routes.rb
 
  get 'detaliifacturare', to: 'detaliifacturares#datefacturare', as: 'datefacturare'  
 
  post 'datefacturarep', to: 'detaliifacturares#datefacturarep'
  



  resources :detaliifacturares, only: [:index, :edit, :create, :update, :datefacturare, :show]
  
  
  


  post 'admin/create', to: 'admin#create', as: 'create_admin'
  

  
  
  get '/aplicatie-calcul-nutritional', to: 'valorinutritionales#aplicatie', as: :aplicatie


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
  
  get 'sesiune_vara', to: 'home#sesiune_vara'
  get 'home/recuperare_cursuri', to: 'home#recuperare_cursuri'
  get 'home/index1', to: 'home#index1'
  get 'home/index'
  get 'vajikarana', to: 'home#vajikarana'
  
  get 'newsletter', to: 'home#newsletter'
  
  get 'sesiune_vara_raport', to: 'home#sesiune_vara_raport'
  get 'copyright', to: 'home#copyright'
  get 'documente', to: 'home#documente'
  get 'user77', to: 'home#user77'
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

  get '/xlsxtopg/preluare_nume_cpa', to: 'xlsxtopg#preluare_nume_cpa', as: 'preluare_nume_cpa_xlsxtopg'
  get '/xlsxtopg/actualizare_cpa_date_facturare', to: 'xlsxtopg#actualizare_cpa_date_facturare', as: 'actualizare_cpa_date_facturare_xlsxtopg'
  

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
  
 
match '*path', to: 'application#handle_routing_error', via: :all

end