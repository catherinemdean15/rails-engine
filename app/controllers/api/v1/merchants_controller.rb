class Api::V1::MerchantsController < ApplicationController
  def index
    paginate(params[:per_page], params[:page], Merchant)
  end

  def show
    render json: Merchant.find(params[:id])
  end

  def items
    merchant = Merchant.find(params[:merchant_id])
    render json: merchant.items
  end

  def merchants_items
    merchant = Merchant.find(params[:merchant_id])
    render json: { merchant_name: merchant.name,
                   items: merchant.items }
  end

  def most_items
    render json: Merchant.most_items(params[:quantity])
  end
end
