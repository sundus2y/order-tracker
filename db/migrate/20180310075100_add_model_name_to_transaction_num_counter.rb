class AddModelNameToTransactionNumCounter < ActiveRecord::Migration
  def change
    add_column :transaction_num_counters, :klass_name, :string
  end
end
