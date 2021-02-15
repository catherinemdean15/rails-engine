class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :invoices
  has_many :items


  def self.most_items(quantity)
    joins(invoices: :invoice_items)
      .select('merchants.*, invoice_items.quantity AS total_items')
      .order('total_items DESC')
      .limit(quantity)
  end
end
