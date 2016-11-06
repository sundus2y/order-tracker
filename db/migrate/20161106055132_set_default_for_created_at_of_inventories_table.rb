class SetDefaultForCreatedAtOfInventoriesTable < ActiveRecord::Migration
  def up
    execute "ALTER TABLE inventories ALTER COLUMN created_at SET DEFAULT now()"
    execute "ALTER TABLE inventories ALTER COLUMN updated_at SET DEFAULT now()"
  end
end
