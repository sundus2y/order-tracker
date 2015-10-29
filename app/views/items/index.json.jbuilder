json.array!(@items) do |item|
  json.extract! item, :id, :name, :description, :item_number
  json.url item_url(item, format: :json)
end
