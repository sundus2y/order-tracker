json.array!(@orders) do |order|
  json.extract! order, :id, :title, :notes, :creator_id, :order_type
  json.url order_url(order, format: :json)
end
