require 'rails_helper'

describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get api_v1_merchants_path
    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

  it 'can get one merchant by its id' do
    id = create(:merchant).id

    get api_v1_merchant_path(id)

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to eq(id)

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)
  end

  xit 'fails with 404 if merchant does not exist' do
    get api_v1_merchant_path(999_999)
    expect(response.status).to eq(404)
  end

  it "can get a merchant's items" do
    id = create(:merchant).id
    id_2 = create(:merchant).id
    create_list(:item, 10, merchant_id: id)
    create_list(:item, 5, merchant_id: id_2)

    get api_v1_merchant_items_path(id)

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items.count).to eq(10)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(Integer)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to eq(id)
    end
  end

  it 'returns an array even if it has no items' do
    merchant = create(:merchant)

    get api_v1_merchant_items_path(merchant)

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful
    expect(items.count).to eq(0)
    expect(items).to be_an(Array)
  end

  it 'returns a specific amount of merchants at a time' do
    (create_list :merchant, 10)

    get api_v1_merchants_path({ per_page: 5 })

    expect(response).to be_successful
    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(5)
  end

  it 'returns different pages of merchants' do
    (create_list :merchant, 12)
    merchant = (create :merchant)
    (create_list :merchant, 7)
    get api_v1_merchants_path({ per_page: 5, page: 3 })

    expect(response).to be_successful
    merchants = response.body
    expect(merchants).to include(merchant.to_json)
  end

  it 'returns an array even if the page has no data' do
    (create_list :merchant, 20)

    get api_v1_merchants_path({ per_page: 5, page: 7 })

    merchants = JSON.parse(response.body, symbolize_names: true)

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
    expect(merchant_and_items[:items].first[:name]).to eq(item.name)
  end

  it 'retuns an amount of merchants ranked by total number of items sold' do
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

    # merchant 1
    (create :invoice_item, item_id: items1.first.id, invoice_id: invoice1.id, quantity: 1, unit_price: 2.19)
    (create :invoice_item, item_id: items1[1].id, invoice_id: invoice2.id, quantity: 14, unit_price: 19.99)
    # merchant 2 has no sales
    # merchant 3
    (create :invoice_item, item_id: items3[0].id, invoice_id: invoice3.id, quantity: 159, unit_price: 3.60)

    # merchant 4
    (create :invoice_item, item_id: items4[1].id, invoice_id: invoice4.id, quantity: 2, unit_price: 9.19)

    get api_v1_most_items_path({ quantity: 3})
    expect(response).to be_successful
    merchants_by_sales = JSON.parse(response.body, symbolize_names: true)
    expect(merchants_by_sales.count).to eq(3)
    expect(merchants_by_sales[0][:name]).to eq(merchant3.name)
    expect(merchants_by_sales[1][:name]).to eq(merchant1.name)
    expect(merchants_by_sales[2][:name]).to eq(merchant4.name)
  end
end
