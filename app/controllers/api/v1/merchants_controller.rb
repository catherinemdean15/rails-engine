class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(paginate(params[:per_page],
                                                 params[:page],
                                                 Merchant))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def items
    merchant = Merchant.find(params[:merchant_id])
    render json: ItemSerializer.new(merchant.items)
  end

  def merchants_items
    merchant = Merchant.find(params[:merchant_id])
    render json: { merchant_name: merchant.name,
                   items: ItemSerializer.new(merchant.items)}
  end

  def most_items
    render json: {data: Merchant.most_items(params[:quantity])}
  end

  def find_one
    merchant = Merchant.partial_match(params[:name], "name").first if params[:name]
    render json: MerchantSerializer.new(merchant)
  end
end
