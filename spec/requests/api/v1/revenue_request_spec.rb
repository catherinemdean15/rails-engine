require 'rails_helper'

describe 'Revenue API' do
  it 'provides a total revenue from a date range' do
    merchant1 = create(:merchant)
    items1 = create_list(:item, 2, merchant_id: merchant1.id)
    merchant2 = create(:merchant)
    items2 = create_list(:item, 2, merchant_id: merchant2.id)

    customer = (create :customer)
    invoice1 = (create :invoice, customer_id: customer.id, merchant_id: merchant1.id, status: 'shipped')
    invoice2 = (create :invoice, customer_id: customer.id, merchant_id: merchant1.id, status: 'canceled')
    invoice3 = (create :invoice, customer_id: customer.id, merchant_id: merchant2.id, status: 'shipped')
    invoice4 = (create :invoice, customer_id: customer.id, merchant_id: merchant2.id, status: 'shipped')
    invoice5 = (create :invoice, customer_id: customer.id, merchant_id: merchant2.id, status: 'shipped')

    (create :invoice_item, item_id: items1.first.id, invoice_id: invoice1.id, quantity: 10, unit_price: 2.00,
                           created_at: '2020-03-25 09:54:09')
    (create :invoice_item, item_id: items1[1].id, invoice_id: invoice2.id, quantity: 14, unit_price: 19.99,
                           created_at: '2020-03-27 09:54:09')
    (create :invoice_item, item_id: items2[0].id, invoice_id: invoice3.id, quantity: 10, unit_price: 2.00,
                           created_at: '2020-03-28 09:54:09')
    (create :invoice_item, item_id: items2[1].id, invoice_id: invoice4.id, quantity: 2, unit_price: 9.19,
                           created_at: '2020-04-25 09:54:09')
    (create :invoice_item, item_id: items2[1].id, invoice_id: invoice5.id, quantity: 15, unit_price: 8.17,
                           created_at: '2020-03-25 09:54:09')

    (create :transaction, invoice_id: invoice1.id, result: 'complete')
    (create :transaction, invoice_id: invoice2.id, result: 'complete')
    (create :transaction, invoice_id: invoice3.id, result: 'complete')
    (create :transaction, invoice_id: invoice4.id, result: 'complete')
    (create :transaction, invoice_id: invoice5.id, result: 'rejected')

    get api_v1_revenue_path({ start_date: '2020-03-20', end_date: '2020-04-01' })

    total_revenue = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(total_revenue.count).to eq(1)
    expect(matching_merchants[:data]).to eq('40.00')
  end
end
