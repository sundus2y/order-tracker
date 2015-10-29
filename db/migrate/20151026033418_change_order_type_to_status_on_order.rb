class ChangeOrderTypeToStatusOnOrder < ActiveRecord::Migration
  def change
    rename_column :orders, :order_type, :status
  end
end
