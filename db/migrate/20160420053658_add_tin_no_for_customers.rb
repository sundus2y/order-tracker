class AddTinNoForCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :tin_no, :string
  end
end
