class AddMoreAttributesToItems < ActiveRecord::Migration
  def change
    add_column :items, :model, :string
    add_column :items, :car, :string
    add_column :items, :part_class, :string
  end
end
