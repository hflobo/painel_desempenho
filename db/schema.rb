# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_16_235126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "alerts", force: :cascade do |t|
    t.string "descricao"
    t.date "data_ciencia"
    t.date "data_providencia"
    t.integer "criador_id"
    t.integer "destinatario_id"
    t.bigint "indicator_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "texto_providencia"
    t.boolean "providencia"
    t.boolean "arquivado"
    t.index ["indicator_id"], name: "index_alerts_on_indicator_id"
  end

  create_table "dashboards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "nome"
    t.index ["user_id"], name: "index_dashboards_on_user_id"
  end

  create_table "goals", force: :cascade do |t|
    t.integer "ano"
    t.integer "periodo"
    t.decimal "valor", precision: 3, scale: 2
    t.bigint "indicator_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["indicator_id"], name: "index_goals_on_indicator_id"
  end

  create_table "indicators", force: :cascade do |t|
    t.string "nome"
    t.string "sigla"
    t.string "abrangencia"
    t.string "unidade_de_medida"
    t.integer "qtd_apuracoes_ano"
    t.integer "qtd_metas_ano"
    t.bigint "user_id", null: false
    t.bigint "objective_id", null: false
    t.bigint "region_id", null: false
    t.bigint "pai_indicator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "tipo_meta_max", default: true, null: false
    t.index ["objective_id"], name: "index_indicators_on_objective_id"
    t.index ["region_id"], name: "index_indicators_on_region_id"
    t.index ["user_id"], name: "index_indicators_on_user_id"
  end

  create_table "kpis", force: :cascade do |t|
    t.string "destaque"
    t.integer "ordem"
    t.string "tipo_grafico"
    t.bigint "indicator_id", null: false
    t.bigint "dashboard_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "nome", limit: 50
    t.index ["dashboard_id"], name: "index_kpis_on_dashboard_id"
    t.index ["indicator_id"], name: "index_kpis_on_indicator_id"
  end

  create_table "objectives", force: :cascade do |t|
    t.string "tipo"
    t.string "nome"
    t.string "descricao"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "regions", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false
    t.string "name", limit: 80
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "values", force: :cascade do |t|
    t.integer "ano"
    t.integer "periodo"
    t.decimal "valor", precision: 3, scale: 2
    t.bigint "indicator_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["indicator_id"], name: "index_values_on_indicator_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "alerts", "indicators"
  add_foreign_key "alerts", "users", column: "criador_id"
  add_foreign_key "alerts", "users", column: "destinatario_id"
  add_foreign_key "dashboards", "users"
  add_foreign_key "goals", "indicators"
  add_foreign_key "indicators", "indicators", column: "pai_indicator_id"
  add_foreign_key "indicators", "objectives"
  add_foreign_key "indicators", "regions"
  add_foreign_key "indicators", "users"
  add_foreign_key "kpis", "dashboards"
  add_foreign_key "kpis", "indicators"
  add_foreign_key "values", "indicators"
end
