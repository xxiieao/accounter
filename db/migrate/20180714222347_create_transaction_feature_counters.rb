# frozen_string_literal: true

class CreateTransactionFeatureCounters < ActiveRecord::Migration[5.2]
  def change
    create_table :transaction_feature_counters do |t|
      t.string  :feature_name,  limit: 30
      t.string  :feature_value, limit: 30
      t.integer :counter, default: 0
      t.integer :purpose_id, default: nil
      t.timestamps

      t.index %i[feature_name feature_value], name: 'name_value_index'
      t.index :purpose_id
    end
  end
end
