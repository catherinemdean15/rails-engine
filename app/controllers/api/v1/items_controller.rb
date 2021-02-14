class Api::V1::ItemsController < ApplicationController
  def index
    page_size = params[:per_page].to_i || 20
    page_number = params[:page].to_i || 1
    low_index = ((page_number - 1) * page_size)
    high_index = (page_number * page_size) - 1
    render json: Item.all[low_index..high_index]
  end

  def show
    render json: Item.find(params[:id])
  end

  def create
    render json: Item.create!(item_params)
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
