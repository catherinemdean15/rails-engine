# frozen_string_literal: true

require 'rails_helper'

describe Merchant do
  describe 'validations' do
    it { should validate_presence_of :name }
  end
  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many :items }
  end
  describe 'class methods' do
    before :each do
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant3 = create(:merchant)
      @merchant4 = create(:merchant)

      @items1 = (create_list :item, 2, merchant_id: @merchant1.id)
      @items2 = (create_list :item, 2, merchant_id: @merchant2.id)
      @items3 = (create_list :item, 2, merchant_id: @merchant3.id)
      @items4 = (create_list :item, 2, merchant_id: @merchant4.id)

      customer = (create :customer)

      invoice1 = (create :invoice, customer_id: customer.id, merchant_id: @merchant1.id, status: 'shipped')
      invoice2 = (create :invoice, customer_id: customer.id, merchant_id: @merchant1.id, status: 'canceled')
      invoice3 = (create :invoice, customer_id: customer.id, merchant_id: @merchant3.id, status: 'shipped')
      invoice4 = (create :invoice, customer_id: customer.id, merchant_id: @merchant4.id, status: 'shipped')

      (create :transaction, invoice_id: invoice1.id, result: 'success')
      (create :transaction, invoice_id: invoice2.id, result: 'success')
      (create :transaction, invoice_id: invoice3.id, result: 'success')
      (create :transaction, invoice_id: invoice4.id, result: 'success')

      (create :invoice_item, item_id: @items1.first.id, invoice_id: invoice1.id, quantity: 1, unit_price: 2.19)
      (create :invoice_item, item_id: @items1[1].id, invoice_id: invoice2.id, quantity: 14, unit_price: 19.99)
      (create :invoice_item, item_id: @items3[0].id, invoice_id: invoice3.id, quantity: 159, unit_price: 3.60)
      (create :invoice_item, item_id: @items4[1].id, invoice_id: invoice4.id, quantity: 2, unit_price: 9.19)
    end

    it 'merchants_by_revenue' do
      expect(Merchant.merchants_by_revenue(1).first[:name]).to eq(@merchant3.name)
    end

    it 'most items' do
      expected = Merchant.most_items(3).map do |merchant|
        merchant[:name]
      end
      expect(expected).to eq([@merchant3.name, @merchant4.name, @merchant1.name])
    end
  end

  describe 'instance methods' do
    it 'total_revenue' do
      @merchant1 = create(:merchant)
      @items1 = create_list(:item, 2, merchant_id: @merchant1.id)
      @merchant2 = create(:merchant)
      @items2 = create_list(:item, 2, merchant_id: @merchant2.id)

      customer = (create :customer)

      invoice1 = (create :invoice, customer_id: customer.id, merchant_id: @merchant1.id, status: 'shipped',
                                   created_at: '2020-03-25 09:54:09')
      invoice2 = (create :invoice, customer_id: customer.id, merchant_id: @merchant1.id, status: 'packaged',
                                   created_at: '2020-03-27 09:54:09')
      invoice3 = (create :invoice, customer_id: customer.id, merchant_id: @merchant2.id, status: 'shipped',
                                   created_at: '2020-03-28 09:54:09')
      invoice4 = (create :invoice, customer_id: customer.id, merchant_id: @merchant2.id, status: 'shipped',
                                   created_at: '2020-04-25 09:54:09')
      invoice5 = (create :invoice, customer_id: customer.id, merchant_id: @merchant2.id, status: 'shipped',
                                   created_at: '2020-03-25 09:54:09')

      (create :invoice_item, item_id: @items1.first.id, invoice_id: invoice1.id, quantity: 8, unit_price: 2.00)
      (create :invoice_item, item_id: @items1[1].id, invoice_id: invoice2.id, quantity: 5, unit_price: 20.00)
      (create :invoice_item, item_id: @items2[0].id, invoice_id: invoice3.id, quantity: 10, unit_price: 2.00)

      (create :transaction, invoice_id: invoice1.id, result: 'success')
      (create :transaction, invoice_id: invoice2.id, result: 'success')
      (create :transaction, invoice_id: invoice3.id, result: 'success')
      (create :transaction, invoice_id: invoice4.id, result: 'success')
      (create :transaction, invoice_id: invoice5.id, result: 'rejected')

      expect(@merchant1.total_revenue).to eq(16.00)
    end
  end
end
