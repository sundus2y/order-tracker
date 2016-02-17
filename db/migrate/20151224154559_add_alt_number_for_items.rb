class AddAltNumberForItems < ActiveRecord::Migration
  def change
    add_column :items, :original_number, :string
  end
end
