require 'rails_helper'

describe 'Items API' do
  it 'sends a list of items' do
    merchant1 = create(:merchant)
    create_list(:item, 3, merchant_id: merchant1.id)

    merchant2 = create(:merchant)
    create_list(:item, 3, merchant_id: merchant2.id)

    get api_v1_items_path
    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(items.count).to eq(6)

    items.each do |item|
      expect(item).to have_key(:id)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
    end
  end

  it 'returns a specific amount items at a time' do
    merchant1 = create(:merchant)
    create_list(:item, 3, merchant_id: merchant1.id)

    merchant2 = create(:merchant)
    create_list(:item, 3, merchant_id: merchant2.id)

    get api_v1_items_path({ per_page: 2 })

    expect(response).to be_successful
    items = JSON.parse(response.body, symbolize_names: true)[:data]

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

    expect(items).to include(item.name)
    expect(items).to include(item.description)
    expect(items).to include(item.id.to_s)
  end

  it 'can get one item by its id' do
    merchant1 = create(:merchant)
    id = create(:item, merchant_id: merchant1.id).id
    get api_v1_item_path(id)

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(item).to have_key(:id)
    expect(item[:id]).to eq(id.to_s)

    expect(item[:attributes]).to have_key(:name)
    expect(item[:attributes][:name]).to be_a(String)

    expect(item[:attributes]).to have_key(:description)
    expect(item[:attributes][:description]).to be_a(String)

    expect(item[:attributes]).to have_key(:unit_price)
    expect(item[:attributes][:unit_price]).to be_a(Float)
  end

  it 'can create an item' do
    merchant1 = create(:merchant)
    item_params = {
      name: 'New Name',
      description: 'This is a description',
      unit_price: 23.89,
      merchant_id: merchant1.id
    }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    post '/api/v1/items', headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last
    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end

  it 'can destroy an item' do
    merchant1 = create(:merchant)
    id = create(:item, merchant_id: merchant1.id).id

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect { Item.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can update an item' do
    merchant1 = create(:merchant)
    id = create(:item, merchant_id: merchant1.id).id

    previous_name = Item.last.name
    item_params = { name: 'Updated Name' }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({ item: item_params })
    item = Item.find(id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq('Updated Name')
  end

  it 'has a sad path for updating the item' do
    merchant1 = create(:merchant)
    id = create(:item, merchant_id: merchant1.id).id

    item_params = { name: nil }
    headers = { 'CONTENT_TYPE' => 'application/json' }

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({ item: item_params })

    expect(response.status).to eq(404)
  end

  it 'can find merchant info from an item id' do
    merchant1 = create(:merchant)
    item = create(:item, merchant_id: merchant1.id)

    get "/api/v1/items/#{item.id}/merchant"
    merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful
    expect(merchant[:attributes][:name]).to eq(merchant1.name)
    expect(merchant[:id]).to eq(merchant1.id.to_s)
  end

  it 'can find one item based on search criteria' do
    merchant1 = create(:merchant)
    create_list(:item, 2, merchant_id: merchant1.id)
    item_1 = create(:item, name: 'Cool Item', merchant_id: merchant1.id)
    item_2 = create(:item, name: 'Super Cool Item', merchant_id: merchant1.id)

    get api_v1_items_find_path({ name: 'cool' })
    matching_item = JSON.parse(response.body, symbolize_names: true)
    expect(matching_item.count).to eq(1)
    expect(matching_item[:data][:attributes][:name]).to eq(item_1.name)
  end

  it 'has a sad path for find one item' do
    merchant1 = create(:merchant)
    create_list(:item, 2, merchant_id: merchant1.id)

    get api_v1_items_find_path({ name: 'cool' })
    matching_item = JSON.parse(response.body, symbolize_names: true)
    expect(matching_item[:data]).to eq({})
  end

  it 'can find all items based on search criteria' do
    merchant1 = create(:merchant)
    create_list(:item, 5, merchant_id: merchant1.id)
    item_1 = create(:item, name: 'Cool Item', merchant_id: merchant1.id)
    item_2 = create(:item, name: 'Super Cool Item', merchant_id: merchant1.id)
    item_3 = create(:item, name: 'Cool Cool Cool', merchant_id: merchant1.id)

    get api_v1_items_find_all_path({ name: 'cool' })
    matching_items = JSON.parse(response.body, symbolize_names: true)
    expect(matching_items[:data].count).to eq(3)
    expect(matching_items[:data].first[:attributes][:name]).to eq(item_1.name)
    expect(matching_items[:data][1][:attributes][:name]).to eq(item_2.name)
    expect(matching_items[:data][2][:attributes][:name]).to eq(item_3.name)
  end

  it 'has a sad path for finding all items based on search criteria' do
    merchant1 = create(:merchant)
    create_list(:item, 5, merchant_id: merchant1.id)

    get api_v1_items_find_all_path({ name: 'cool' })
    matching_items = JSON.parse(response.body, symbolize_names: true)
    expect(matching_items[:data]).to eq([])
  end
end
