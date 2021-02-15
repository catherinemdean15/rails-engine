class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :invoices
  has_many :items


  def self.most_items(quantity)
    joins(invoices: :invoice_items)
      .where('invoices.status = ?', 'shipped')
      .select('merchants.id, merchants.name, sum(invoice_items.quantity) AS count')
      .group(:id)
      .order('count DESC')
      .limit(quantity)
  end
end
