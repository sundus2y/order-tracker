class RenameStoreToStoreIdOnSales < ActiveRecord::Migration
  def change
    change_table :sales do |t|
      t.rename :store, :store_id
    end
  end
end
