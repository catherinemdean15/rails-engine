class Item < ApplicationRecord
  validates_presence_of :name,
                        :description,
                        :unit_price
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.items_by_revenue
    joins(invoices: :transactions)
      .where("invoices.status='shipped' AND transactions.result='success'")
      .select('items.*, sum(quantity * invoice_items.unit_price) AS revenue')
      .group(:id)
      .order('revenue DESC')
  end
end
