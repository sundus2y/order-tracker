json.array!(@sales) do |sale|
  json.extract! sale, :id, :customer_id, :store_id, :remark
  json.url sale_url(sale, format: :json)
end
