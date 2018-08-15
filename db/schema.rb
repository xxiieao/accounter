# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_14_222347) do
  create_table 'purposes', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'the_name', limit: 30
    t.integer 'counter', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'transaction_feature_counters', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'feature_name', limit: 30
    t.string 'feature_value', limit: 30
    t.integer 'counter', default: 0
    t.integer 'purpose_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['feature_name', 'feature_value'], name: 'name_value_index'
    t.index ['purpose_id'], name: 'index_transaction_feature_counters_on_purpose_id'
  end

  create_table 'transactions', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.date 'the_date'
    t.string 'the_type', limit: 30
    t.string 'shop', limit: 30
    t.string 'payer', limit: 30
    t.decimal 'amount', precision: 10, scale: 2
    t.decimal 'balance', precision: 10, scale: 2
    t.integer 'purpose_id'
    t.boolean 'confirmed', default: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['confirmed'], name: 'index_transactions_on_confirmed'
    t.index ['purpose_id'], name: 'index_transactions_on_purpose_id'
    t.index ['the_date'], name: 'index_transactions_on_the_date'
  end
end
