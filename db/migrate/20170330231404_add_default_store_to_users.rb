class AddDefaultStoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_store_id, :integer
  end
end
