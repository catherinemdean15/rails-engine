# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.float :unit_price

      t.timestamps
    end
  end
end
