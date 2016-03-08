class AddPrevAndNextNumberToItems < ActiveRecord::Migration
  def change
    add_column :items, :prev_number, :string
    add_column :items, :next_number, :string
  end
end
