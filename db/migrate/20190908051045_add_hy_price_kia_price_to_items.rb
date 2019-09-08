class AddHyPriceKiaPriceToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :hy_price, :decimal, precision: 11, scale: 2
    add_column :items, :kia_price, :decimal, precision: 11, scale: 2
  end
end
