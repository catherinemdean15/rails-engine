require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    merchant1 = create(:merchant)
    create_list(:item, 3, merchant_id: merchant1.id)

    merchant2 = create(:merchant)
    create_list(:item, 3, merchant_id: merchant2.id)

    get api_v1_items_path
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(6)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(Integer)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)
    end
  end

  it 'returns a specific amount items at a time' do
    merchant1 = create(:merchant)
    create_list(:item, 3, merchant_id: merchant1.id)

    merchant2 = create(:merchant)
    create_list(:item, 3, merchant_id: merchant2.id)

    get api_v1_items_path({ per_page: 2 })

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(2)
  end

  it 'returns different pages of merchants' do
    merchant1 = create(:merchant)
    create_list(:item, 10, merchant_id: merchant1.id)
    item = create(:item, merchant_id: merchant1.id)
    merchant2 = create(:merchant)
    create_list(:item, 3, merchant_id: merchant2.id)
    get api_v1_items_path({ per_page: 5, page: 3 })

    expect(response).to be_successful
    items = response.body
    expect(items).to include(item.to_json)
  end
end
