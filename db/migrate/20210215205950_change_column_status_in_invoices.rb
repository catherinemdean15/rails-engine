class ChangeColumnStatusInInvoices < ActiveRecord::Migration[6.1]
  def change
    change_column :invoices, :status, :string
  end
end
