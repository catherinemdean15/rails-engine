class Api::V1::RevenuesController < ApplicationController
  def date_range
    if params[:end].present? && params[:start].present? && params[:start] < params[:end]
      end_date = params[:end].to_date.end_of_day
      start_date = params[:start].to_date.beginning_of_day
      revenue = InvoiceItem.revenue_by_date(start_date, end_date)
      render json: RevenueSerializer.revenue_by_date(revenue)
    else
      render json: { 'error' => {} }, status: 400
    end
  end

  def merchant_revenue
    merchant = Merchant.find(params[:id])
    revenue = merchant.invoice_items.joins(invoice: :transactions)
                      .where("invoices.status='shipped' AND transactions.result='success'")
                      .sum('invoice_items.quantity * invoice_items.unit_price')
    render json: RevenueSerializer.merchant_revenue(merchant, revenue)
  end

  def items_by_revenue
    if params[:quantity]
      render json: ItemRevenueSerializer.new(Item.items_by_revenue.limit(params[:quantity]))
    else
      render json: { 'error' => {} }, status: 400
    end
  end

  def unshipped_orders
    if params[:quantity]
      render json: UnshippedOrderSerializer.new(Invoice.unshipped_orders.limit(params[:quantity]))
    else
      render json: { 'error' => {} }, status: 400
    end
  end

  def weekly
    render json: WeeklyRevenueSerializer.new(Invoice.weekly_revenue)
    require 'pry'; binding.pry
  end
end
