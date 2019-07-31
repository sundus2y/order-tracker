class RenameColumnOrderTable < ActiveRecord::Migration[5.2]
  def change
    rename_column :orders, :created_by, :creator_id
  end
end
