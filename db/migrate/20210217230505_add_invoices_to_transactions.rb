# frozen_string_literal: true

class AddInvoicesToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_reference :transactions, :invoice, null: false, foreign_key: true
  end
end
