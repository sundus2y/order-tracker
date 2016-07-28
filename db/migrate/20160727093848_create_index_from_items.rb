class CreateIndexFromItems < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE INDEX items_lower_name ON items using gin (name gin_trgm_ops);
      CREATE INDEX items_lower_description ON items using gin (description gin_trgm_ops);
      CREATE INDEX items_lower_item_number ON items using gin (item_number gin_trgm_ops);
      CREATE INDEX items_lower_original_number ON items using gin (original_number gin_trgm_ops);
      CREATE INDEX items_lower_prev_number ON items using gin (prev_number gin_trgm_ops);
      CREATE INDEX items_lower_next_number ON items using gin (next_number gin_trgm_ops);
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX items_lower_name;
      DROP INDEX items_lower_description;
      DROP INDEX items_lower_item_number;
      DROP INDEX items_lower_original_number;
      DROP INDEX items_lower_prev_number;
      DROP INDEX items_lower_next_number;
    SQL
  end
end
