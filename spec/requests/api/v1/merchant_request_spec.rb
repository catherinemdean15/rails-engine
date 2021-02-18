require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get api_v1_merchants_path
    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)

      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'can get one merchant by its id' do
    merchant = create(:merchant)

    get api_v1_merchant_path(merchant)

    merchant_response = JSON.parse(response.body, symbolize_names: true)
    expect(response).to be_successful
    expect(merchant_response[:data]).to have_key(:id)
    expect(merchant_response[:data][:id].to_i).to eq(merchant.id)

    expect(merchant_response[:data][:attributes]).to have_key(:name)
    expect(merchant_response[:data][:attributes][:name]).to eq(merchant.name)
  end

  it "can get a merchant's items" do
    id = create(:merchant).id
    id_2 = create(:merchant).id
    create_list(:item, 10, merchant_id: id)
    create_list(:item, 5, merchant_id: id_2)

    get api_v1_merchant_items_path(id)

    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful
    expect(items.count).to eq(10)

    items.each do |item|
      expect(item).to have_key(:id)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to eq(id)
    end
  end

  it 'returns an array even if it has no items' do
    merchant = create(:merchant)

    get api_v1_merchant_items_path(merchant)

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(items.count).to eq(0)
    expect(items).to be_an(Array)
  end

  it 'returns a specific amount of merchants at a time' do
    (create_list :merchant, 10)

    get api_v1_merchants_path({ per_page: 5 })

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchants.count).to eq(5)
  end

  it 'returns different pages of merchants' do
    (create_list :merchant, 12)
    merchant = (create :merchant)
    (create_list :merchant, 7)
    get api_v1_merchants_path({ per_page: 5, page: 3 })

    expect(response).to be_successful
    merchants = response.body

    expect(merchants).to include(merchant.id.to_s)
    expect(merchants).to include(merchant.name)
  end

  it 'returns an array even if the page has no data' do
    (create_list :merchant, 20)

    get api_v1_merchants_path({ per_page: 5, page: 7 })

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(merchants.count).to eq(0)
    expect(merchants).to be_an(Array)
  end

  it 'can return a merchant and the merchant items' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    item = create(:item, merchant_id: merchant1.id)
    create_list(:item, 9, merchant_id: merchant1.id)
    create_list(:item, 5, merchant_id: merchant2.id)

    get api_v1_merchant_merchants_items_path(merchant1)

    expect(response).to be_successful
    merchant_and_items = JSON.parse(response.body, symbolize_names: true)
    expect(merchant_and_items.count).to eq(2)
    expect(merchant_and_items[:merchant_name]).to eq(merchant1.name)
    expect(merchant_and_items[:items][:data].first[:attributes][:name]).to eq(item.name)
  end

  it 'retuns an amount of merchants ranked by total number of items sold' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    merchant3 = create(:merchant)
    merchant4 = create(:merchant)

    items1 = (create_list :item, 2, merchant_id: merchant1.id)
    items2 = (create_list :item, 2, merchant_id: merchant2.id)
    items3 = (create_list :item, 2, merchant_id: merchant3.id)
    items4 = (create_list :item, 2, merchant_id: merchant4.id)

    customer = (create :customer)

    invoice1 = (create :invoice, customer_id: customer.id, merchant_id: merchant1.id, status: 'shipped')
    invoice2 = (create :invoice, customer_id: customer.id, merchant_id: merchant1.id, status: 'canceled')
    invoice3 = (create :invoice, customer_id: customer.id, merchant_id: merchant3.id, status: 'shipped')
    invoice4 = (create :invoice, customer_id: customer.id, merchant_id: merchant4.id, status: 'shipped')

    (create :invoice_item, item_id: items1.first.id, invoice_id: invoice1.id, quantity: 1, unit_price: 2.19)
    (create :invoice_item, item_id: items1[1].id, invoice_id: invoice2.id, quantity: 14, unit_price: 19.99)
    (create :invoice_item, item_id: items3[0].id, invoice_id: invoice3.id, quantity: 159, unit_price: 3.60)
    (create :invoice_item, item_id: items4[1].id, invoice_id: invoice4.id, quantity: 2, unit_price: 9.19)

    get api_v1_merchants_most_items_path({ quantity: 3 })

    expect(response).to be_successful
    merchants_by_sales = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(merchants_by_sales.count).to eq(3)
    expect(merchants_by_sales[0][:name]).to eq(merchant3.name)
    expect(merchants_by_sales[1][:name]).to eq(merchant4.name)
    expect(merchants_by_sales[2][:name]).to eq(merchant1.name)
  end

  it 'can find one merchant based on search criteria' do
    (create_list :merchant, 20)
    merchant1 = (create :merchant, name: 'Candy Store')
    merchant2 = (create :merchant, name: 'Some Candy')

    get api_v1_merchants_find_path({ name: 'candy' })
    matching_merchants = JSON.parse(response.body, symbolize_names: true)
    expect(matching_merchants.count).to eq(1)
    expect(matching_merchants[:data][:attributes][:name]).to eq(merchant1.name)
  end

  it 'can find all merchants based on search criteria' do
    (create_list :merchant, 3)
    merchant1 = (create :merchant, name: 'Candy Store')
    merchant2 = (create :merchant, name: 'Some Candy')
    merchant3 = (create :merchant, name: 'Candy Candy')

    get api_v1_merchants_find_all_path({ name: 'candy' })
    matching_merchants = JSON.parse(response.body, symbolize_names: true)
    expect(matching_merchants[:data].count).to eq(3)
    expect(matching_merchants[:data].first[:attributes][:name]).to eq(merchant1.name)
    expect(matching_merchants[:data][1][:attributes][:name]).to eq(merchant2.name)
    expect(matching_merchants[:data][2][:attributes][:name]).to eq(merchant3.name)
  end
end
