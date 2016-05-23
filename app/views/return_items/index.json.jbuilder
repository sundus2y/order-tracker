json.array!(@return_items) do |return_item|
  json.extract! return_item, :id, :sale_item_id, :qty
  json.url return_item_url(return_item, format: :json)
end
