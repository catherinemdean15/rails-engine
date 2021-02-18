class Api::V1::RevenuesController < ApplicationController
  def date_range
    if params[:end].nil? || params[:start].nil? || params[:start] > params[:end]
      render json: { 'error' => {} }, status: 400
    else
      end_date = params[:end].to_date.end_of_day
      start_date = params[:start].to_date.beginning_of_day
      revenue = InvoiceItem.revenue_by_date(start_date, end_date)
      render json: RevenueSerializer.revenue_by_date(revenue)
    end
  end

  def merchant_revenue
    merchant = Merchant.find(params[:id])
    revenue = merchant.invoice_items.joins(invoice: :transactions)
                      .where("invoices.status='shipped' AND transactions.result='success'")
                      .sum('invoice_items.quantity * invoice_items.unit_price')
    render json: RevenueSerializer.merchant_revenue(merchant, revenue)
  end
end
