# frozen_string_literal: true

class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity, :unit_price
  belongs_to :item
  belongs_to :invoice

  def self.revenue_by_date(start_date, end_date)
    joins(invoice: :transactions)
      .where("invoices.status='shipped' AND transactions.result='success'")
      .where('invoices.created_at >= ? AND invoices.created_at<= ?', start_date, end_date)
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
