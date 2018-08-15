# frozen_string_literal: true

class CreatePurposes < ActiveRecord::Migration[5.2]
  def change
    create_table :purposes do |t|
      t.string  :the_name,    limit: 30
      t.integer :counter, default: 0
      t.timestamps
    end
  end
end
