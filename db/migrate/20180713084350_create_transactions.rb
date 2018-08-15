# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.date   :the_date
      t.string :the_type, limit: 30
      t.string :shop,     limit: 30
      t.string :payer,    limit: 30
      t.decimal :amount,  precision: 10, scale: 2
      t.decimal :balance, precision: 10, scale: 2
      t.integer :purpose_id
      t.boolean :confirmed, default: false
      t.timestamps

      t.index :the_date
      t.index :purpose_id
      t.index :confirmed
    end
  end
end
