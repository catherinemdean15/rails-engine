# frozen_string_literal: true

class CreateInvoiceItems < ActiveRecord::Migration[6.1]
  def change
    create_table :invoice_items do |t|
      t.integer :quantity
      t.float :unit_price
      t.integer :status
      t.references :invoice, foreign_key: true
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
