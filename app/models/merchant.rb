# frozen_string_literal: true

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

  def self.merchants_by_revenue(quantity)
    Merchant.joins(invoices: %i[invoice_items transactions])
            .where("invoices.status='shipped' AND transactions.result='success'")
            .select('merchants.id, merchants.name, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
            .group(:id)
            .order('revenue DESC')
            .limit(quantity)
  end

  def total_revenue
    invoice_items.joins(invoice: :transactions)
                 .where("invoices.status='shipped' AND transactions.result='success'")
                 .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
