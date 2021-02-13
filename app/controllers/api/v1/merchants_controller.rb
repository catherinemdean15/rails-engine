class Api::V1::MerchantsController < ApplicationController
  def index
    page_size = params[:per_page].to_i || 20
    page_number = params[:page].to_i || 1
    low_index = ((page_number - 1) * page_size)
    high_index = (page_number * page_size) - 1
    render json: Merchant.all[low_index..high_index]
  end

  def show
    render json: Merchant.find(params[:id])
  end
end
