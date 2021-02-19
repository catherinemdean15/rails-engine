# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ApplicationController
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
      rescue StandardError
        render json: { 'error' => {} }, status: 404
      end

      def destroy
        Item.delete(params[:id])
      end

      def merchant
        render json: MerchantSerializer.new(Item.find(params[:item_id]).merchant)
      end

      def find_one
        item = Item.partial_match(params[:name], 'name').first
        if item.present?
          render json: ItemSerializer.new(item)
        else
          render json: { data: {} }
        end
      end

      def find_all
        items = Item.partial_match(params[:name], 'name')
        if items.present?
          render json: ItemSerializer.new(items)
        else
          render json: { data: [] }
        end
      end

      private

      def item_params
        params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
      end
    end
  end
end
