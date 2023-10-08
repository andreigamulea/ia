# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_08_165544) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accescurs2324s", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "septembrie"
    t.boolean "octombrie"
    t.boolean "noiembrie"
    t.boolean "decembrie"
    t.boolean "ianuarie"
    t.boolean "februarie"
    t.boolean "martie"
    t.boolean "aprilie"
    t.boolean "mai"
    t.boolean "iunie"
    t.boolean "iulie"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "all"
    t.boolean "all1"
    t.boolean "septembrie1"
    t.boolean "octombrie1"
    t.boolean "noiembrie1"
    t.boolean "decembrie1"
    t.boolean "ianuarie1"
    t.boolean "februarie1"
    t.boolean "martie1"
    t.boolean "aprilie1"
    t.boolean "mai1"
    t.boolean "iunie1"
    t.boolean "iulie1"
    t.index ["user_id"], name: "index_accescurs2324s_on_user_id"
  end

  create_table "adresacomenzi", force: :cascade do |t|
    t.integer "comanda_id"
    t.boolean "adresacoincide", default: false
    t.string "prenume"
    t.string "nume"
    t.string "numecompanie"
    t.string "cui"
    t.string "tara"
    t.string "judet"
    t.string "localitate"
    t.string "codpostal"
    t.string "strada"
    t.string "numar"
    t.text "altedate"
    t.string "telefon"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comanda_id"], name: "index_adresacomenzi_on_comanda_id"
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "comandas", force: :cascade do |t|
    t.date "datacomenzii"
    t.integer "numar"
    t.string "statecomanda1"
    t.string "statecomanda2"
    t.string "stateplata1"
    t.string "stateplata2"
    t.string "stateplata3"
    t.integer "user_id"
    t.string "emailcurrent"
    t.string "emailplata"
    t.decimal "total"
    t.string "plataprin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "prodid"
    t.string "prodcod"
    t.string "telefon"
    t.index ["prodcod"], name: "index_comandas_on_prodcod"
    t.index ["prodid"], name: "index_comandas_on_prodid"
  end

  create_table "comenzi_prods", force: :cascade do |t|
    t.bigint "prod_id", null: false
    t.bigint "comanda_id", null: false
    t.date "datainceput"
    t.date "datasfarsit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "validat"
    t.integer "taxa2324"
    t.index ["comanda_id"], name: "index_comenzi_prods_on_comanda_id"
    t.index ["prod_id"], name: "index_comenzi_prods_on_prod_id"
    t.index ["taxa2324"], name: "index_comenzi_prods_on_taxa2324"
    t.index ["user_id"], name: "index_comenzi_prods_on_user_id"
    t.index ["validat"], name: "index_comenzi_prods_on_validat"
  end

  create_table "cursuri_history", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "listacursuri_id", null: false
    t.integer "cursuri_id", null: false
    t.date "datainceput"
    t.date "datasfarsit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.text "observatii"
    t.string "modificatde"
    t.index ["listacursuri_id"], name: "index_cursuri_history_on_listacursuri_id"
    t.index ["user_id"], name: "index_cursuri_history_on_user_id"
  end

  create_table "cursuriayurvedas", force: :cascade do |t|
    t.string "grupa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cursuris", force: :cascade do |t|
    t.date "datainceput"
    t.date "datasfarsit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "listacursuri_id"
    t.integer "user_id"
    t.string "sursa"
    t.index ["listacursuri_id"], name: "index_cursuris_on_listacursuri_id"
    t.index ["user_id"], name: "index_cursuris_on_user_id"
  end

  create_table "descriereeroris", force: :cascade do |t|
    t.text "descriere"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "detaliifacturares", force: :cascade do |t|
    t.integer "user_id"
    t.string "prenume"
    t.string "nume"
    t.string "numecompanie"
    t.string "cui"
    t.string "tara"
    t.string "codpostal"
    t.string "strada"
    t.string "numar"
    t.text "altedate"
    t.string "telefon"
    t.string "adresaemail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "localitate"
    t.string "judet"
    t.string "prenume1"
    t.string "nume1"
    t.string "numecompanie1"
    t.string "tara1"
    t.string "codpostal1"
    t.string "strada1"
    t.string "numar1"
    t.string "localitate1"
    t.string "judet1"
    t.text "altedate1"
    t.string "telefon1"
    t.boolean "use_alternate_shipping", default: false
  end

  create_table "facturas", force: :cascade do |t|
    t.bigint "comanda_id", null: false
    t.bigint "user_id", null: false
    t.integer "numar"
    t.integer "numar_comanda"
    t.date "data_emiterii"
    t.string "prenume"
    t.string "nume"
    t.string "nume_companie"
    t.string "cui"
    t.string "tara"
    t.string "localitate"
    t.string "judet"
    t.string "cod_postal"
    t.string "strada"
    t.string "numar_adresa"
    t.string "produs"
    t.integer "cantitate"
    t.decimal "pret_unitar"
    t.decimal "valoare_tva"
    t.decimal "valoare_totala"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["comanda_id"], name: "index_facturas_on_comanda_id"
    t.index ["status"], name: "index_facturas_on_status"
    t.index ["user_id"], name: "index_facturas_on_user_id"
  end

  create_table "importanta", force: :cascade do |t|
    t.integer "codimp"
    t.string "grad"
    t.string "descgrad"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lista_vegetales", force: :cascade do |t|
    t.string "specie"
    t.string "sinonime"
    t.string "parteutilizata"
    t.string "mentiunirestrictii"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "numar"
    t.date "dataa"
    t.index ["dataa"], name: "index_lista_vegetales_on_dataa"
    t.index ["mentiunirestrictii"], name: "index_lista_vegetales_on_mentiunirestrictii"
    t.index ["parteutilizata"], name: "index_lista_vegetales_on_parteutilizata"
    t.index ["sinonime"], name: "index_lista_vegetales_on_sinonime"
    t.index ["specie"], name: "index_lista_vegetales_on_specie"
  end

  create_table "listacursuris", force: :cascade do |t|
    t.string "nume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listaproprietatis", force: :cascade do |t|
    t.integer "idx"
    t.string "proprietateter"
    t.string "tipp"
    t.integer "srota"
    t.text "definire"
    t.text "sinonime"
    t.string "selectie"
    t.integer "sel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idx"], name: "index_listaproprietatis_on_idx"
    t.index ["proprietateter"], name: "index_listaproprietatis_on_proprietateter"
    t.index ["srota"], name: "index_listaproprietatis_on_srota"
  end

  create_table "paginisites", force: :cascade do |t|
    t.string "nume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plante_partis", force: :cascade do |t|
    t.integer "idx"
    t.integer "cpl"
    t.string "parte"
    t.string "part"
    t.string "clasa"
    t.string "invpp"
    t.string "tippp"
    t.string "recomandari"
    t.string "textsursa"
    t.string "starereprez"
    t.string "z"
    t.string "healthrel"
    t.string "compozitie"
    t.string "etich"
    t.string "healthrelrom"
    t.string "propspeciale"
    t.string "selectie"
    t.string "lucru"
    t.string "s"
    t.string "sel"
    t.integer "index2"
    t.string "ordvol"
    t.string "selpz"
    t.string "selpzn"
    t.string "sels"
    t.string "selz"
    t.string "selnr"
    t.string "t10"
    t.string "t11"
    t.string "t12"
    t.string "t13"
    t.string "t14"
    t.string "t15"
    t.string "t16"
    t.string "b"
    t.string "r"
    t.string "c"
    t.string "imp"
    t.string "testat"
    t.string "g1"
    t.string "g2"
    t.string "g3"
    t.string "g4"
    t.string "g5"
    t.string "g6"
    t.string "vir"
    t.string "vip"
    t.string "imaginepp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpl"], name: "index_plante_partis_on_cpl"
    t.index ["idx"], name: "index_plante_partis_on_idx"
    t.index ["index2"], name: "index_plante_partis_on_index2"
  end

  create_table "plantes", force: :cascade do |t|
    t.integer "idp"
    t.string "tip"
    t.string "subt"
    t.string "nume"
    t.string "denbot"
    t.string "numesec"
    t.string "numesec2"
    t.string "numeayu"
    t.string "fam"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idp"], name: "index_plantes_on_idp", unique: true
    t.index ["nume"], name: "index_plantes_on_nume", unique: true
  end

  create_table "prods", force: :cascade do |t|
    t.string "nume"
    t.text "detalii"
    t.string "luna"
    t.decimal "pret"
    t.integer "valabilitatezile"
    t.string "curslegatura"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "linkstripe"
    t.string "status"
    t.string "cod"
  end

  create_table "recomandaris", force: :cascade do |t|
    t.integer "listaproprietati_id"
    t.integer "idpr"
    t.integer "idp"
    t.integer "idpp"
    t.string "imp"
    t.string "tipp"
    t.integer "srota"
    t.string "proprietate"
    t.string "propeng"
    t.string "propayur"
    t.string "propgerm"
    t.string "completari"
    t.string "sursa"
    t.string "sel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idpp"], name: "index_recomandaris_on_idpp"
    t.index ["listaproprietati_id"], name: "index_recomandaris_on_listaproprietati_id"
    t.index ["srota"], name: "index_recomandaris_on_srota"
  end

  create_table "srota", force: :cascade do |t|
    t.integer "codsrota"
    t.integer "codsr"
    t.string "numesrota"
    t.string "numescurt"
    t.string "explicatie"
    t.string "origine"
    t.string "parti"
    t.string "functii"
    t.string "observatie"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["codsr"], name: "index_srota_on_codsr"
    t.index ["codsrota"], name: "index_srota_on_codsrota"
  end

  create_table "tipuri_props", force: :cascade do |t|
    t.integer "idxcp"
    t.string "cp"
    t.string "explicatie"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_ips", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "curspromo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_ips_on_user_id"
  end

  create_table "user_paginisites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "paginisite_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paginisite_id"], name: "index_user_paginisites_on_paginisite_id"
    t.index ["user_id"], name: "index_user_paginisites_on_user_id"
  end

  create_table "user_unhappies", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "email"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_videos", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "datainceput"
    t.datetime "datasfarsit"
    t.string "nume"
    t.string "tip"
  end

  create_table "userprods", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "prod_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prod_id"], name: "index_userprods_on_prod_id"
    t.index ["user_id"], name: "index_userprods_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.integer "role"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
    t.string "stripe_customer_id"
    t.boolean "gdpr", default: false
    t.string "current_sign_in_token"
    t.string "google_token"
    t.string "provider"
    t.string "uid"
    t.string "google_refresh_token"
    t.datetime "last_sign_in_at"
    t.datetime "current_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "current_sign_in_ip"
    t.integer "sign_in_count"
    t.string "limba"
    t.string "telefon"
    t.string "telefon2"
    t.string "telefon3"
    t.integer "grupa"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["grupa"], name: "index_users_on_grupa"
    t.index ["limba"], name: "index_users_on_limba"
    t.index ["name"], name: "index_users_on_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "valorinutritionales", force: :cascade do |t|
    t.integer "cod"
    t.string "aliment"
    t.float "calorii"
    t.float "proteine"
    t.float "lipide"
    t.float "carbohidrati"
    t.float "fibre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "observatii"
    t.index ["aliment"], name: "index_valorinutritionales_on_aliment"
    t.index ["calorii"], name: "index_valorinutritionales_on_calorii"
    t.index ["carbohidrati"], name: "index_valorinutritionales_on_carbohidrati"
    t.index ["cod"], name: "index_valorinutritionales_on_cod"
    t.index ["fibre"], name: "index_valorinutritionales_on_fibre"
    t.index ["lipide"], name: "index_valorinutritionales_on_lipide"
    t.index ["proteine"], name: "index_valorinutritionales_on_proteine"
  end

  create_table "videos", force: :cascade do |t|
    t.string "nume"
    t.text "descriere"
    t.string "sursa"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tip"
    t.integer "ordine"
    t.string "luna"
    t.string "cod"
    t.index ["luna"], name: "index_videos_on_luna"
  end

  add_foreign_key "accescurs2324s", "users"
  add_foreign_key "comenzi_prods", "comandas"
  add_foreign_key "comenzi_prods", "prods"
  add_foreign_key "cursuri_history", "listacursuris"
  add_foreign_key "cursuri_history", "users", on_delete: :nullify
  add_foreign_key "facturas", "comandas"
  add_foreign_key "facturas", "users"
  add_foreign_key "user_ips", "users"
  add_foreign_key "user_paginisites", "paginisites"
  add_foreign_key "user_paginisites", "users"
  add_foreign_key "userprods", "prods"
  add_foreign_key "userprods", "users"
end
