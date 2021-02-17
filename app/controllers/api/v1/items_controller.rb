class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(paginate(params[:per_page],
                                    params[:page],
                                    Item))
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.create!(item_params)
    render json: ItemSerializer.new(item), status: :created
  end

  def update
    item = Item.find(params[:id])
    item.update!(item_params)
    render json: ItemSerializer.new(item)
  end

  def destroy
    Item.delete(params[:id])
  end

  def merchant
    render json: MerchantSerializer.new(Item.find(params[:item_id]).merchant)
  end

  def find_one
    item = Item.partial_match(params[:name], "name").first if params[:name]
    render json: ItemSerializer.new(item)
  end

  def find_all
    items = Item.partial_match(params[:name], "name") if params[:name]
    render json: ItemSerializer.new(items)
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
