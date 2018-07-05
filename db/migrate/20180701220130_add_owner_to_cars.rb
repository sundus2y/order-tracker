class AddOwnerToCars < ActiveRecord::Migration
  def change
    add_column :cars, :owner, :string
  end
end
