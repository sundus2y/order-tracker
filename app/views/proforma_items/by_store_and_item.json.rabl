collection @proforma_items

attributes :id,:qty,:unit_price

child(:item) { attributes :id,:name,:original_number }
child(:proforma) do
    attributes :id,:created_at
    child(:customer) { attributes :name,:phone }
end