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
    it 'most items' do
      merchant1 = (create :merchant)
      merchant2 = (create :merchant)
      merchant3 = (create :merchant)
      merchant4 = (create :merchant)

      items1 = (create_list :item, 2, merchant_id: merchant1.id)
      items2 = (create_list :item, 2, merchant_id: merchant2.id)
      items3 = (create_list :item, 2, merchant_id: merchant3.id)
      items4 = (create_list :item, 2, merchant_id: merchant4.id)

      customer = (create :customer)

      invoice1 = (create :invoice, customer_id: customer.id, merchant_id: merchant1.id, status: 1)
      invoice2 = (create :invoice, customer_id: customer.id, merchant_id: merchant1.id, status: 0)
      invoice3 = (create :invoice, customer_id: customer.id, merchant_id: merchant3.id, status: 1)
      invoice4 = (create :invoice, customer_id: customer.id, merchant_id: merchant4.id, status: 1)

      (create :invoice_item, item_id: items1.first.id, invoice_id: invoice1.id, quantity: 1, unit_price: 2.19)
      (create :invoice_item, item_id: items1[1].id, invoice_id: invoice2.id, quantity: 14, unit_price: 19.99)
      (create :invoice_item, item_id: items3[0].id, invoice_id: invoice3.id, quantity: 159, unit_price: 3.60)
      (create :invoice_item, item_id: items4[1].id, invoice_id: invoice4.id, quantity: 2, unit_price: 9.19)

      expected = Merchant.most_items(3).map do |merchant|
        merchant[:name]
      end
      expect(expected).to eq([merchant3.name, merchant1.name, merchant4.name])
    end

  end
end
