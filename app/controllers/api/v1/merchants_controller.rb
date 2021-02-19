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
                   items: ItemSerializer.new(merchant.items) }
  end

  def most_items
    if params[:quantity].nil?
      render json: { 'error' => {} }, status: 400
    else
      render json: MerchantItemsSoldSerializer.new(Merchant.most_items(params[:quantity]))
    end
  end

  def find_one
    merchant = Merchant.partial_match(params[:name], 'name')
    if merchant.present?
      render json: MerchantSerializer.new(merchant.first)
    else
      render json: { data: {} }
    end
  end

  def find_all
    merchants = Merchant.partial_match(params[:name], 'name')
    if merchants.present?
      render json: MerchantSerializer.new(merchants)
    else
      render json: { data: [] }
    end
  end
end
