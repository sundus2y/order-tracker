namespace :migrate do
  desc 'Migrate COL'
  task col: :environment do
    ItemCopy.delete_all

    ItemCopy.copy_from "lib/tasks/#{ENV['FILE']}.csv"
    puts "Items to import = #{ItemCopy.count}"

    update_sql = <<-SQL
UPDATE items
SET    #{ENV['COL']} = item_copies.#{ENV['COL']}
FROM   item_copies
WHERE  items.item_number = item_copies.item_number;
    SQL
    results = ActiveRecord::Base.connection.execute(update_sql);
    puts "Items updated = #{results.cmd_tuples}"

    insert_sql = <<-SQL
INSERT INTO items(item_number, name, original_number, #{ENV['COL']}, brand, made)
(
  SELECT DISTINCT ic.item_number, ic.name, ic.item_number, ic.#{ENV['COL']}, '#{ENV['BRAND']}' as brand, 'KOREA' as made
  FROM item_copies ic
  LEFT OUTER JOIN items i
  ON ic.item_number = i.item_number
  WHERE i.item_number IS NULL
)
    SQL
    results = ActiveRecord::Base.connection.execute(insert_sql);
    puts "Items created = #{results.cmd_tuples}"

    ItemCopy.delete_all
  end
end
