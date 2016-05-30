collection @sale_items

attributes :id,:qty,:unit_price,:total_returned_qty

child(:item) { attributes :id,:name,:original_number }
child(:sale) do
    attributes :id,:created_at
    child(:customer) { attributes :name,:phone }
end
child(:return_items) { attributes :id,:qty,:created_at,:note }