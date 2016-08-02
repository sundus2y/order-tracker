class RenameTypeToStoreTypeForStoreTable < ActiveRecord::Migration
  def change
    change_table :stores do |t|
      t.rename :type, :store_type
    end
  end
end
