class AddCarIdToProforma < ActiveRecord::Migration
  def change
    add_column :proformas, :car_id, :integer
  end
end
