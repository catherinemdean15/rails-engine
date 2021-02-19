# frozen_string_literal: true

class RemoveInvoiceIdFromTransactions < ActiveRecord::Migration[6.1]
  def change
    remove_column :transactions, :invoice_id
  end
end
