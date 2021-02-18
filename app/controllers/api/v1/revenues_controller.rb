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
end
