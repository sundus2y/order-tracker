class AddMakeFromToFildToItems < ActiveRecord::Migration
  def change
    add_column :items, :make_from, :date
    add_column :items, :make_to, :date
  end
end
