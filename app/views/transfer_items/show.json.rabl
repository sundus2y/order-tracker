object @transfer_item

attributes :id,:qty,:status

child(:item) { attributes :id,:name,:description,:original_number,:item_number }
