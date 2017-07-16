class AddFsNumToSalesOrder < ActiveRecord::Migration
  def change
    add_column :sales, :fs_num, :string
  end
end
