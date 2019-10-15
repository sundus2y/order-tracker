def create_versions(inventory, transfer_items, sale_items)
  store_id = inventory['store_id']
  running_total = inventory['qty']

  from_transfer_items = to_transfer_items = []
  transfer_items.each do |ti|
    if ti['item_id'] == inventory['item_id'] && ti['from_store_id'] == store_id
      ti['action'] = :+
      from_transfer_items.push(ti)
    end
    if ti['item_id'] == inventory['item_id'] && ti['to_store_id'] == store_id
      ti['action'] = :-
      to_transfer_items.push(ti)
    end
  end
  select_sales_items = sale_items.select {|si| si['item_id'] == inventory['item_id'] && si['store_id'] == store_id}

  transaction_items = from_transfer_items + to_transfer_items + select_sales_items
  transaction_items.sort_by! {|ti| ti['updated_at']}.reverse!

  csv_value = []
  csv_value << get_csv_entry(inventory, inventory, store_id, running_total)
  transaction_items.each_with_index do |transaction_item, index|
    if index + 1 == transaction_items.count
      type = 'create'
    else
      type = 'update'
    end
    if transaction_item['store_id'] || transaction_item['action'] == :+
      running_total = running_total + transaction_item['qty']
    elsif transaction_item['action'] == :-
      running_total = running_total - transaction_item['qty']
    else
      skip = true
      raise "Found Unknown Transaction Item: #{transaction_item}"
      Rails.logger.error("Found Unknown Transaction Item: #{transaction_item}")
    end
    unless skip
      csv_value << get_csv_entry(inventory, transaction_item, store_id, running_total, type)
    end
  end
  create_csv_file(csv_value)
  Version.copy_from('lib/tasks/versions.csv')
end

def get_csv_entry(inventory, transaction_item, store_id, running_total, type = 'update')
  val = <<-VAL
Inventory,#{inventory['id']},#{type},,"--- 
id: #{inventory['id']}
store_id: #{store_id}
item_id: #{inventory['item_id']}
qty: #{running_total}
location: '#{inventory['location']}'
created_at: #{inventory['created_at']}
updated_at: #{transaction_item['updated_at']}
deleted_at:  
",#{transaction_item['updated_at']},
  VAL
  val.chomp!
end

def create_csv_file(csv_value)
  versions_file = File.open('lib/tasks/versions.csv', 'w+')
  versions_file.puts('item_type,item_id,event,whodunnit,object,created_at,object_changes')
  versions_file.puts(csv_value.join("\n"))
  versions_file.close
end

def get_inventories
  iv_sql = <<-SQL
SELECT *
FROM inventories
  SQL
  ActiveRecord::Base.connection.execute(iv_sql)
end

def get_transfer_items
  tr_sql = <<-SQL
SELECT transfers.from_store_id, transfers.to_store_id, transfer_items.*
FROM transfer_items
INNER JOIN transfers
ON transfer_items.transfer_id = transfers.id
WHERE transfer_items.deleted_at IS NULL
AND transfer_items.status = 'received'
  SQL
  ActiveRecord::Base.connection.execute(tr_sql)
end

def get_sale_items
  s_sql = <<-SQL
SELECT sales.store_id, sale_items.*
FROM sale_items
INNER JOIN sales
ON sale_items.sale_id = sales.id
WHERE sale_items.deleted_at IS NULL
AND sale_items.status != 'draft'
AND sale_items.status != 'ordered'
  SQL
  ActiveRecord::Base.connection.execute(s_sql)
end

namespace :setup do
  desc "Create old versions of Inventories"
  task create_old_versions: :environment do
    inventories = get_inventories
    transfer_items = get_transfer_items
    sale_items = get_sale_items

    progressbar = ProgressBar.create(:title => "Create Version for Inventory", :starting_at => 0, :total => inventories.count, format: "%a %e %P% Processed: %c from %C")
    inventories.each do |inventory|
      create_versions(inventory, transfer_items, sale_items)
      progressbar.increment
    end
  end
end
