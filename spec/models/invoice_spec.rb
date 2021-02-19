require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many(:invoice_items) }
    it { should have_many(:transactions) }
  end

  describe 'class methods' do
    before :each do
      @merchant1 = create(:merchant)
      @items1 = create_list(:item, 2, merchant_id: @merchant1.id)
      @merchant2 = create(:merchant)
      @items2 = create_list(:item, 2, merchant_id: @merchant2.id)

      customer = (create :customer)

      @invoice1 = (create :invoice, customer_id: customer.id, merchant_id: @merchant1.id, status: 'shipped',
                                    created_at: '2020-03-25 09:54:09')
      @invoice2 = (create :invoice, customer_id: customer.id, merchant_id: @merchant1.id, status: 'packaged',
                                    created_at: '2020-03-27 09:54:09')
      @invoice3 = (create :invoice, customer_id: customer.id, merchant_id: @merchant2.id, status: 'shipped',
                                    created_at: '2020-03-28 09:54:09')
      @invoice4 = (create :invoice, customer_id: customer.id, merchant_id: @merchant2.id, status: 'shipped',
                                    created_at: '2020-04-25 09:54:09')
      @invoice5 = (create :invoice, customer_id: customer.id, merchant_id: @merchant2.id, status: 'shipped',
                                    created_at: '2020-03-25 09:54:09')

      (create :invoice_item, item_id: @items1.first.id, invoice_id: @invoice1.id, quantity: 8, unit_price: 2.00)
      (create :invoice_item, item_id: @items1[1].id, invoice_id: @invoice2.id, quantity: 5, unit_price: 20.00)
      (create :invoice_item, item_id: @items2[0].id, invoice_id: @invoice3.id, quantity: 10, unit_price: 2.00)
      (create :invoice_item, item_id: @items2[1].id, invoice_id: @invoice4.id, quantity: 3, unit_price: 10.00)
      (create :invoice_item, item_id: @items2[1].id, invoice_id: @invoice5.id, quantity: 15, unit_price: 8.17)

      (create :transaction, invoice_id: @invoice1.id, result: 'success')
      (create :transaction, invoice_id: @invoice2.id, result: 'success')
      (create :transaction, invoice_id: @invoice3.id, result: 'success')
      (create :transaction, invoice_id: @invoice4.id, result: 'success')
      (create :transaction, invoice_id: @invoice5.id, result: 'rejected')
    end

    it 'unshipped_orders' do
      expect(Invoice.unshipped_orders).to eq([@invoice2])
    end

    xit 'weekly_revenue' do
      expect(INvoice.weekly_revenue).to eq([])
    end
  end
end
