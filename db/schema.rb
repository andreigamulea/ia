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

ActiveRecord::Schema[7.1].define(version: 2024_10_20_220143) do
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

  create_table "accescurs2425", force: :cascade do |t|
    t.integer "user_id"
    t.boolean "septembrie", default: false
    t.boolean "octombrie", default: false
    t.boolean "noiembrie", default: false
    t.boolean "decembrie", default: false
    t.boolean "ianuarie", default: false
    t.boolean "februarie", default: false
    t.boolean "martie", default: false
    t.boolean "aprilie", default: false
    t.boolean "mai", default: false
    t.boolean "iunie", default: false
    t.boolean "iulie", default: false
    t.boolean "all", default: false
    t.boolean "all1", default: false
    t.boolean "septembrie1", default: false
    t.boolean "octombrie1", default: false
    t.boolean "noiembrie1", default: false
    t.boolean "decembrie1", default: false
    t.boolean "ianuarie1", default: false
    t.boolean "februarie1", default: false
    t.boolean "martie1", default: false
    t.boolean "aprilie1", default: false
    t.boolean "mai1", default: false
    t.boolean "iunie1", default: false
    t.boolean "iulie1", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "an32324s", force: :cascade do |t|
    t.string "email"
    t.string "nume"
    t.string "telefon"
    t.string "sep"
    t.string "oct"
    t.string "nov"
    t.string "dec"
    t.string "ian"
    t.string "feb"
    t.string "mar"
    t.string "apr"
    t.string "mai"
    t.string "iun"
    t.string "iul"
    t.string "pret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "comenzi_prod1s", force: :cascade do |t|
    t.bigint "prod_id"
    t.bigint "user_id"
    t.date "datainceput"
    t.date "datasfarsit"
    t.string "validat"
    t.integer "taxa2324"
    t.integer "cantitate"
    t.decimal "pret_bucata", precision: 10, scale: 2
    t.decimal "pret_total", precision: 10, scale: 2
    t.bigint "comanda_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "obs"
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
    t.integer "cantitate"
    t.decimal "pret_bucata", precision: 10, scale: 2
    t.decimal "pret_total", precision: 10, scale: 2
    t.string "obs"
    t.integer "taxa2425"
    t.index ["comanda_id"], name: "index_comenzi_prods_on_comanda_id"
    t.index ["prod_id"], name: "index_comenzi_prods_on_prod_id"
    t.index ["taxa2324"], name: "index_comenzi_prods_on_taxa2324"
    t.index ["user_id"], name: "index_comenzi_prods_on_user_id"
    t.index ["validat"], name: "index_comenzi_prods_on_validat"
  end

  create_table "contracte_acces_emails", force: :cascade do |t|
    t.integer "contracte_id"
    t.string "email"
    t.integer "idcontractor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contracte_useris", force: :cascade do |t|
    t.integer "user_id"
    t.string "email"
    t.integer "idcontractor"
    t.integer "contracte_id"
    t.text "contract_content"
    t.text "signature_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nume_voluntar"
    t.string "domiciliu_voluntar"
    t.string "ci_voluntar"
    t.string "eliberat_de"
    t.date "eliberat_data"
    t.integer "perioada_contract"
    t.string "coordonator_v"
    t.date "data_inceperii"
    t.text "semnatura_voluntar"
    t.text "semnatura_administrator"
    t.string "localitate_voluntar"
    t.string "strada_voluntar"
    t.string "numarstrada_voluntar"
    t.string "bloc_voluntar"
    t.string "judet_voluntar"
    t.string "prenume"
    t.string "cod_contract"
    t.integer "nr_contract_referinta"
    t.string "status"
    t.string "telefon_voluntar"
    t.text "semnatura1"
    t.text "semnatura2"
    t.text "semnatura3"
    t.text "semnatura4"
    t.date "expira_la"
    t.date "data_cerere"
    t.date "data_gdpr"
    t.date "data_posta_ssm"
    t.date "data_bifa_ssm"
    t.date "data_posta_isu"
    t.date "data_bifa_isu"
    t.date "data_cv"
    t.date "data_fisa_postului"
    t.boolean "vazut_video_ssm", default: false
    t.boolean "vazut_video_isu", default: false
  end

  create_table "contractes", force: :cascade do |t|
    t.integer "user_id"
    t.string "email"
    t.string "tip"
    t.string "denumire"
    t.integer "contor"
    t.text "textcontract"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nume_firma"
    t.string "sediu_firma"
    t.string "cont_bancar"
    t.string "banca_firma"
    t.string "cui_firma"
    t.string "reprezentant_firma"
    t.string "calitate_reprezentant"
    t.text "semnatura_admin"
    t.string "cod_contract"
    t.string "denumire_post"
    t.string "locul_desfasurarii"
    t.string "departament"
    t.string "subordonare"
    t.string "relatii_functionale"
    t.integer "contor_start"
    t.integer "valabilitate_luni"
    t.text "sarcini_voluntar"
    t.text "responsabilitati_voluntar"
    t.text "conditii_lucru"
    t.string "video_ssm"
    t.string "video_isu"
    t.string "email_coordonator"
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

  create_table "date_facturares", force: :cascade do |t|
    t.integer "user_id"
    t.integer "firma_id"
    t.string "email"
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
    t.string "localitate"
    t.string "judet"
    t.string "grupa2324"
    t.string "cpa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cod"
    t.string "cnp"
    t.string "grupa2425"
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

  create_table "facturaproformas", force: :cascade do |t|
    t.bigint "comanda_id", null: false
    t.bigint "user_id", null: false
    t.bigint "prod_id", null: false
    t.string "numar_factura"
    t.string "numar_comanda"
    t.date "data_emiterii"
    t.string "prenume"
    t.string "nume"
    t.string "nume_companie"
    t.string "cui"
    t.string "tara"
    t.string "localitate"
    t.string "judet"
    t.string "strada"
    t.string "numar_adresa"
    t.string "cod_postal"
    t.string "altedate"
    t.string "telefon"
    t.string "produs"
    t.integer "cantitate"
    t.decimal "pret_unitar"
    t.decimal "valoare_tva"
    t.decimal "valoare_totala"
    t.string "cod_firma"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "serie_factura"
    t.string "plata_prin"
    t.date "data_platii"
    t.string "obs"
    t.index ["comanda_id"], name: "index_facturaproformas_on_comanda_id"
    t.index ["prod_id"], name: "index_facturaproformas_on_prod_id"
    t.index ["user_id"], name: "index_facturaproformas_on_user_id"
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

  create_table "firmas", force: :cascade do |t|
    t.string "nume_institutie"
    t.string "cui"
    t.string "rc"
    t.string "adresa"
    t.string "banca"
    t.string "cont"
    t.string "serie"
    t.integer "nrinceput"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cod"
  end

  create_table "firmeproformas", force: :cascade do |t|
    t.string "nume_institutie"
    t.string "cui"
    t.string "rc"
    t.string "adresa"
    t.string "banca"
    t.string "cont"
    t.string "serie"
    t.string "nrinceput"
    t.string "tva"
    t.string "cod"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "importanta", force: :cascade do |t|
    t.integer "codimp"
    t.string "grad"
    t.string "descgrad"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "judets", force: :cascade do |t|
    t.string "oasp"
    t.string "denjud"
    t.string "cod"
    t.integer "idjudet"
    t.string "cod_j"
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

  create_table "listacanal1s", force: :cascade do |t|
    t.string "email"
    t.string "nume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listacanal2s", force: :cascade do |t|
    t.string "email"
    t.string "nume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "telefon"
    t.string "platit"
  end

  create_table "listacanal3s", force: :cascade do |t|
    t.string "email"
    t.string "nume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "telefon"
    t.string "platit"
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

  create_table "localitatis", force: :cascade do |t|
    t.string "cod"
    t.integer "judetid"
    t.string "denumire"
    t.string "denj"
    t.string "abr"
    t.string "cod_vechi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modulecursuris", force: :cascade do |t|
    t.string "nume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "newsletters", force: :cascade do |t|
    t.string "nume"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "validat"
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

  create_table "redirection_logs", force: :cascade do |t|
    t.string "original_path"
    t.string "redirected_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "taris", force: :cascade do |t|
    t.string "nume"
    t.string "abr"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipconstitutionals", force: :cascade do |t|
    t.integer "nrtip"
    t.integer "nr"
    t.string "tip"
    t.string "caracteristica"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipuri_props", force: :cascade do |t|
    t.integer "idxcp"
    t.string "cp"
    t.string "explicatie"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tvs", force: :cascade do |t|
    t.string "denumire"
    t.string "link"
    t.string "cine"
    t.integer "canal"
    t.date "datainceput"
    t.time "orainceput"
    t.integer "mininceput"
    t.date "datasfarsit"
    t.time "orasfarsit"
    t.integer "minsfarsit"
    t.integer "user_id"
    t.string "referinta"
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

  create_table "user_modulecursuris", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "modulecursuri_id", null: false
    t.string "validat"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["modulecursuri_id"], name: "index_user_modulecursuris_on_modulecursuri_id"
    t.index ["user_id"], name: "index_user_modulecursuris_on_user_id"
  end

  create_table "user_paginisites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "paginisite_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paginisite_id"], name: "index_user_paginisites_on_paginisite_id"
    t.index ["user_id"], name: "index_user_paginisites_on_user_id"
  end

  create_table "user_tipconstitutionals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tipconstitutional_id", null: false
    t.integer "valoare"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tipconstitutional_id"], name: "index_user_tipconstitutionals_on_tipconstitutional_id"
    t.index ["user_id"], name: "index_user_tipconstitutionals_on_user_id"
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
    t.float "nutritieabsolvit"
    t.string "cpa"
    t.string "cnp"
    t.integer "grupa2425"
    t.jsonb "taxa", default: {}, null: false
    t.jsonb "gr", default: {}, null: false
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
    t.string "linkpdf"
    t.string "link_debian"
    t.index ["luna"], name: "index_videos_on_luna"
  end

  add_foreign_key "accescurs2324s", "users"
  add_foreign_key "comenzi_prods", "comandas"
  add_foreign_key "comenzi_prods", "prods"
  add_foreign_key "cursuri_history", "listacursuris"
  add_foreign_key "cursuri_history", "users", on_delete: :nullify
  add_foreign_key "facturaproformas", "comandas"
  add_foreign_key "facturaproformas", "prods"
  add_foreign_key "facturaproformas", "users"
  add_foreign_key "facturas", "comandas"
  add_foreign_key "facturas", "users"
  add_foreign_key "user_ips", "users"
  add_foreign_key "user_modulecursuris", "modulecursuris"
  add_foreign_key "user_modulecursuris", "users"
  add_foreign_key "user_paginisites", "paginisites"
  add_foreign_key "user_paginisites", "users"
  add_foreign_key "user_tipconstitutionals", "tipconstitutionals"
  add_foreign_key "user_tipconstitutionals", "users"
  add_foreign_key "userprods", "prods"
  add_foreign_key "userprods", "users"
end
