class SetDefaultForCreatedAtOfItemsTable < ActiveRecord::Migration
  def up
    execute "ALTER TABLE Items ALTER COLUMN created_at SET DEFAULT now()"
    execute "ALTER TABLE Items ALTER COLUMN updated_at SET DEFAULT now()"
  end
end
