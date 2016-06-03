collection @items

attributes :name,:original_number,:item_number,:description,:car,:model,:sale_price,:dubai_price,:korea_price,:brand,:made

node(:actions) {|item| item.actions}
node(:inventories_display) {|item| item.inventories_display}
