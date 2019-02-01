object @transfer_item

attributes :id,:qty,:status,:location

child(:item) { attributes :id,:name,:description,:original_number,:item_number,:sale_price,:brand }
