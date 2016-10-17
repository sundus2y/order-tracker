class ChangeLocationTypeOnInventories < ActiveRecord::Migration
  def change
    change_column :inventories, :location, :string
  end
end
