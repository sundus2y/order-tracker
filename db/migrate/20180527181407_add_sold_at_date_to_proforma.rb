class AddSoldAtDateToProforma < ActiveRecord::Migration
  def change
    add_column :proformas, :sold_at, :datetime
  end
end
