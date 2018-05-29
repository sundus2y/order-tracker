class AddCarIdToSale < ActiveRecord::Migration
  def change
    add_column :sales, :car_id, :integer
  end
end
