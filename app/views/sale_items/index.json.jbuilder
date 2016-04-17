json.array!(@sale_items) do |sale_item|
  json.extract! sale_item, :id, :sale_id, :item_id, :qty, :unit_price
  json.url sale_item_url(sale_item, format: :json)
end
