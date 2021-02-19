class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :invoices
  has_many :items
  has_many :invoice_items, through: :items

  def self.most_items(quantity)
    joins(invoices: %i[invoice_items transactions])
      .where("invoices.status='shipped' AND transactions.result='success'")
      .select('merchants.id, merchants.name, sum(invoice_items.quantity) AS count')
      .group(:id)
      .order('count DESC')
      .limit(quantity)
  end
end
