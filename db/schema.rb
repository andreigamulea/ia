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

ActiveRecord::Schema[7.0].define(version: 2023_04_07_090243) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cursuris", force: :cascade do |t|
    t.date "datainceput"
    t.date "datasfarsit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "listacursuri_id"
    t.integer "user_id"
    t.index ["listacursuri_id"], name: "index_cursuris_on_listacursuri_id"
    t.index ["user_id"], name: "index_cursuris_on_user_id"
  end

  create_table "importanta", force: :cascade do |t|
    t.integer "codimp"
    t.string "grad"
    t.string "descgrad"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
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
    t.index ["aliment"], name: "index_valorinutritionales_on_aliment"
    t.index ["calorii"], name: "index_valorinutritionales_on_calorii"
    t.index ["carbohidrati"], name: "index_valorinutritionales_on_carbohidrati"
    t.index ["cod"], name: "index_valorinutritionales_on_cod"
    t.index ["fibre"], name: "index_valorinutritionales_on_fibre"
    t.index ["lipide"], name: "index_valorinutritionales_on_lipide"
    t.index ["proteine"], name: "index_valorinutritionales_on_proteine"
  end

end
