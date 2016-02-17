class AddOrderItemsCountToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :order_items_count, :integer, :default => 0

    Order.reset_column_information
    Order.all.each do |o|
      o.update_attribute :order_items_count, o.order_items.count
    end
  end

  def down
    remove_column :Orders, :order_items_count
  end
end
