class AddDisabledStore < ActiveRecord::Migration
  def change
    add_column :stores, :active, :boolean
  end
end
