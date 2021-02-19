# frozen_string_literal: true

class AddMerchantToItems < ActiveRecord::Migration[6.1]
  def change
    add_reference :items, :merchant, null: false, foreign_key: true
  end
end
