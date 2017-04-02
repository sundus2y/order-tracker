class AddCreatedByToSales < ActiveRecord::Migration
  def change
    add_column :sales, :creator_id, :integer
  end
end
