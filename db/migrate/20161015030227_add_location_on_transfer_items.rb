class AddLocationOnTransferItems < ActiveRecord::Migration
  def change
    add_column :transfer_items, :location, :string
  end
end
