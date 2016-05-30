object @sale_item

attributes :id,:qty,:unit_price,:status

child(:item) { attributes :id,:name,:description,:original_number,:item_number }
