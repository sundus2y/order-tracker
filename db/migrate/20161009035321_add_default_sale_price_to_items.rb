class AddDefaultSalePriceToItems < ActiveRecord::Migration
  def change
    add_column :items, :default_sale_price, :boolean
  end
end
