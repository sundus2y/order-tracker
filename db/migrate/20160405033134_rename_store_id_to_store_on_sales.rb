class RenameStoreIdToStoreOnSales < ActiveRecord::Migration
  def change
    change_table :sales do |t|
      t.rename :store_id, :store
    end
  end
end
