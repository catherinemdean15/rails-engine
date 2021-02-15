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
end
