class AddCategoryToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :category, :integer, :default => 0
  end
end
