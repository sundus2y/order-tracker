json.array!(@customers) do |customer|
  json.extract! customer, :id, :name, :company, :phone, :tin_no
  json.url customer_url(customer, format: :json)
end
