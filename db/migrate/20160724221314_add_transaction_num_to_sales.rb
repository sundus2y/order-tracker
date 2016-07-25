class AddTransactionNumToSales < ActiveRecord::Migration
  def change
    add_column :sales, :transaction_num, :string
  end
end
