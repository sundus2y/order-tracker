object @proforma_item

attributes :id,:remark,:qty,:unit_price,:status

child(:item) { attributes :id,:name,:brand,:original_number,:item_number }
