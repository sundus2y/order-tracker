class AddBrandAndMadeToItems < ActiveRecord::Migration
  def change
    add_column :items, :brand, :string
    add_column :items, :made, :string
  end
end
