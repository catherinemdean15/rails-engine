class ChangeColumnStatusInTransactions < ActiveRecord::Migration[6.1]
  def change
    change_column :transactions, :result, :string
  end
end
