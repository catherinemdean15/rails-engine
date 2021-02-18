require 'rails_helper'

describe 'Revenue API' do
  before :each do
    @merchant1 = create(:merchant)
    items1 = create_list(:item, 2, merchant_id: @merchant1.id)
    @merchant2 = create(:merchant)
    items2 = create_list(:item, 2, merchant_id: @merchant2.id)

    customer = (create :customer)

    invoice1 = (create :invoice, customer_id: customer.id, merchant_id: @merchant1.id, status: 'shipped',
                                 created_at: '2020-03-25 09:54:09')
    invoice2 = (create :invoice, customer_id: customer.id, merchant_id: @merchant1.id, status: 'canceled',
                                 created_at: '2020-03-27 09:54:09')
    invoice3 = (create :invoice, customer_id: customer.id, merchant_id: @merchant2.id, status: 'shipped',
                                 created_at: '2020-03-28 09:54:09')
    invoice4 = (create :invoice, customer_id: customer.id, merchant_id: @merchant2.id, status: 'shipped',
                                 created_at: '2020-04-25 09:54:09')
    invoice5 = (create :invoice, customer_id: customer.id, merchant_id: @merchant2.id, status: 'shipped',
                                 created_at: '2020-03-25 09:54:09')

    (create :invoice_item, item_id: items1.first.id, invoice_id: invoice1.id, quantity: 10, unit_price: 2.00)
    (create :invoice_item, item_id: items1[1].id, invoice_id: invoice2.id, quantity: 14, unit_price: 19.99)
    (create :invoice_item, item_id: items2[0].id, invoice_id: invoice3.id, quantity: 10, unit_price: 2.00)
    (create :invoice_item, item_id: items2[1].id, invoice_id: invoice4.id, quantity: 2, unit_price: 10.00)
    (create :invoice_item, item_id: items2[1].id, invoice_id: invoice5.id, quantity: 15, unit_price: 8.17)

    (create :transaction, invoice_id: invoice1.id, result: 'success')
    (create :transaction, invoice_id: invoice2.id, result: 'success')
    (create :transaction, invoice_id: invoice3.id, result: 'success')
    (create :transaction, invoice_id: invoice4.id, result: 'success')
    (create :transaction, invoice_id: invoice5.id, result: 'rejected')
  end

  it 'provides a total revenue from a date range' do
    get api_v1_revenue_path({ start: '2020-03-20', end: '2020-04-01' })

    total_revenue = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(total_revenue[:attributes][:revenue]).to eq(40.00)
  end

  it 'finds the revenue from a single merchant' do
    get api_v1_path(@merchant1)
    total_revenue = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(total_revenue[:attributes][:revenue]).to eq(20.00)
    expect(total_revenue[:id]).to eq(@merchant1.id.to_s)

    get api_v1_path(@merchant2)
    total_revenue = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(total_revenue[:attributes][:revenue]).to eq(40.00)
    expect(total_revenue[:id]).to eq(@merchant2.id.to_s)
  end
end
