class AddDeletedAtToModels < ActiveRecord::Migration
  def change
    add_column :orders, :deleted_at, :datetime
    add_index :orders, :deleted_at

    add_column :order_items, :deleted_at, :datetime
    add_index :order_items, :deleted_at

    add_column :sales, :deleted_at, :datetime
    add_index :sales, :deleted_at

    add_column :sale_items, :deleted_at, :datetime
    add_index :sale_items, :deleted_at

    add_column :proformas, :deleted_at, :datetime
    add_index :proformas, :deleted_at

    add_column :proforma_items, :deleted_at, :datetime
    add_index :proforma_items, :deleted_at

    add_column :customers, :deleted_at, :datetime
    add_index :customers, :deleted_at

    add_column :cars, :deleted_at, :datetime
    add_index :cars, :deleted_at

    add_column :inventories, :deleted_at, :datetime
    add_index :inventories, :deleted_at

    add_column :items, :deleted_at, :datetime
    add_index :items, :deleted_at

    add_column :return_items, :deleted_at, :datetime
    add_index :return_items, :deleted_at

    add_column :stores, :deleted_at, :datetime
    add_index :stores, :deleted_at

    add_column :transfers, :deleted_at, :datetime
    add_index :transfers, :deleted_at

    add_column :transfer_items, :deleted_at, :datetime
    add_index :transfer_items, :deleted_at
  end
end
