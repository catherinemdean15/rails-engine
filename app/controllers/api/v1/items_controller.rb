class Api::V1::ItemsController < ApplicationController
  def index
    paginate(params[:per_page], params[:page], Item)
  end

  def show
    render json: Item.find(params[:id])
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: item
    else
      render json: { error: 'Item not created',
                     status: 400 }, status: 400
    end
  end

  def update
    render json: Item.update(params[:id], item_params)
  end

  def destroy
    render json: Item.delete(params[:id])
  end

  def merchant
    render json: Item.find(params[:item_id]).merchant
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
