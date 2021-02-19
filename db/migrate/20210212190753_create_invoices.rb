# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.references :merchant, foreign_key: true
      t.references :customer, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
