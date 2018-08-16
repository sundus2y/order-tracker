class AddDeliveryDateAndDownpaymentAmountOnSales < ActiveRecord::Migration
  def change
    add_column :sales, :delivery_date, :datetime
    add_column :sales, :down_payment, :decimal, precision: 11, scale: 2
  end
end
