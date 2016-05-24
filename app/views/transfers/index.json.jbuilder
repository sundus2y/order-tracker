json.array!(@transfers) do |transfer|
  json.extract! transfer, :id, :from_store, :to_store, :note
  json.url transfer_url(transfer, format: :json)
end
