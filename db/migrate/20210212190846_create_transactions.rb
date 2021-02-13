class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.bigint :credit_card_number
      t.bigint :credit_card_expiration_date
      t.integer :result
      t.references :invoice, foreign_key: true

      t.timestamps
    end
  end
end
