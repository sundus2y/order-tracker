class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores do |t|
      t.string :name
      t.string :short_name
      t.string :address
      t.string :phone1
      t.string :phone2
      t.string :type

      t.timestamps null: false
    end
  end
end
