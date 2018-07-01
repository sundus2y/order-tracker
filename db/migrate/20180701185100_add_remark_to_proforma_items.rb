class AddRemarkToProformaItems < ActiveRecord::Migration
  def change
    add_column :proforma_items, :remark, :string
  end
end
