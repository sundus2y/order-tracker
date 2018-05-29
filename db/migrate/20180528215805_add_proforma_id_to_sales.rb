class AddProformaIdToSales < ActiveRecord::Migration
  def change
    add_column :sales, :proforma_id, :integer
  end
end
