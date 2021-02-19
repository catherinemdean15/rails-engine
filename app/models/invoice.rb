# frozen_string_literal: true

class Invoice < ApplicationRecord
  validates_presence_of :status
  belongs_to :merchant
  belongs_to :customer
  has_many :invoice_items
  has_many :transactions

  def self.unshipped_orders
    joins(:transactions, :invoice_items)
      .where("invoices.status='packaged' AND transactions.result='success'")
      .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) AS potential_revenue')
      .group(:id)
      .order('potential_revenue DESC')
  end

  def self.weekly_revenue
    joins(:transactions, :invoice_items)
      .where("invoices.status='shipped' AND transactions.result='success'")
      .select("DATE_TRUNC('week', invoices.created_at) AS week, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue")
      .group('week')
      .order('week')
  end
end
