json.array!(@orders) do |order|
  json.extract! order, :id, :title, :notes, :created_by, :order_type
  json.url order_url(order, format: :json)
end
