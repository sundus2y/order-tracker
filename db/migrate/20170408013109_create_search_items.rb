class CreateSearchItems < ActiveRecord::Migration
  def change
    create_table :search_items do |t|
      t.string :item_number
      t.string :original_number
      t.string :made
      t.string :brand
    end
  end
end
