require 'rails_helper'

describe 'Revenue API' do
  before :each do
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
    (create :invoice_item, item_id: @items2[1].id, invoice_id: invoice4.id, quantity: 3, unit_price: 10.00)
    (create :invoice_item, item_id: @items2[1].id, invoice_id: invoice5.id, quantity: 15, unit_price: 8.17)

    (create :transaction, invoice_id: invoice1.id, result: 'success')
    (create :transaction, invoice_id: invoice2.id, result: 'success')
    (create :transaction, invoice_id: invoice3.id, result: 'success')
    (create :transaction, invoice_id: invoice4.id, result: 'success')
    (create :transaction, invoice_id: invoice5.id, result: 'rejected')
  end

  it 'provides a total revenue from a date range' do
    get api_v1_revenue_path({ start: '2020-03-20', end: '2020-04-01' })

    total_revenue = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(total_revenue[:attributes][:revenue]).to eq(36.00)
  end

  it 'errors if date range is missing or incorrect' do
    get api_v1_revenue_path({ start: nil, end: nil })
    expect(response.status).to eq(400)

    get api_v1_revenue_path({ start: '2020-03-20', end: nil })
    expect(response.status).to eq(400)

    get api_v1_revenue_path({ start: nil, end: '2020-04-01' })
    expect(response.status).to eq(400)

    get api_v1_revenue_path
    expect(response.status).to eq(400)

    get api_v1_revenue_path({ start: '2020-05-20', end: '2020-04-01' })
    expect(response.status).to eq(400)
  end

  it 'finds the revenue from a single merchant' do
    get api_v1_path(@merchant1)
    total_revenue = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(total_revenue[:attributes][:revenue]).to eq(16.00)
    expect(total_revenue[:id]).to eq(@merchant1.id.to_s)

    get api_v1_path(@merchant2)
    total_revenue = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(total_revenue[:attributes][:revenue]).to eq(50.00)
    expect(total_revenue[:id]).to eq(@merchant2.id.to_s)
  end

  it 'finds the items ranked by descending revenue with a quantity' do
    get api_v1_revenue_items_path({ quantity: 2 })
    items_by_revenue = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(items_by_revenue.count).to eq(2)
    expect(items_by_revenue.first[:attributes][:name]).to eq(@items1[1].name)
    expect(items_by_revenue[1][:attributes][:name]).to eq(@items2[1].name)
  end

  it 'errors to find the items with a negative quantity' do
    get api_v1_revenue_items_path({ quantity: -3 })
    expect(response.status).to eq(400)
  end

  it 'errors to find the items with a quantity of characters' do
    get api_v1_revenue_items_path({ quantity: 'hi' })
    expect(response.status).to eq(400)
  end

  it 'lists the potential revenue for unshipped items' do
    get api_v1_revenue_unshipped_path({ quantity: 1 })
    unshipped_items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(unshipped_items.count).to eq(1)
    expect(unshipped_items.first[:attributes][:potential_revenue]).to eq(100)
  end

  it 'errors to find the unshipped items with a negative quantity' do
    get api_v1_revenue_unshipped_path({ quantity: -3 })
    expect(response.status).to eq(400)
  end

  it 'errors to find the unshipped items with a quantity of characters' do
    get api_v1_revenue_unshipped_path({ quantity: 'hi' })
    expect(response.status).to eq(400)
  end

  it 'lists the revenue by week' do
    get api_v1_revenue_weekly_path
    weekly_revenue = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(weekly_revenue.count).to eq(2)
    weekly_revenue.each do |week|
      expect(week).to have_key(:attributes)

      expect(week[:attributes]).to have_key(:week)
      expect(week[:attributes][:week]).to be_a(String)

      expect(week[:attributes]).to have_key(:revenue)
    end
    expect(weekly_revenue.first[:attributes][:revenue]).to eq(36.00)
  end
end
