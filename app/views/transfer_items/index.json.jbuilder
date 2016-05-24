json.array!(@transfer_items) do |transfer_item|
  json.extract! transfer_item, :id, :transfer_id, :item_id, :qty, :status
  json.url transfer_item_url(transfer_item, format: :json)
end
