namespace :item do
  desc "Merge Kia to Hyundai"
  task merge_kia_to_hy: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    sql = <<-SQL
SELECT hy.id AS hy_id, kia.id AS kia_id
FROM items kia
INNER JOIN items hy
ON kia.item_number = hy.item_number 
AND UPPER(kia.brand) != UPPER(hy.brand)
AND UPPER(kia.brand) = 'KIA'
AND (UPPER(hy.brand) = 'HYUNDAI' OR UPPER(hy.brand) = 'HY')
AND kia.disabled = FALSE AND hy.disabled = FALSE
    SQL
    results = ActiveRecord::Base.connection.execute(sql)
    kia_ids = results.to_a.map{|r| r['kia_id']}
    hy_ids = results.to_a.map{|r| r['hy_id']}
    kia_items = Item.active.includes(:inventories).where(id: kia_ids)
    hy_items = Item.active.includes(:inventories).where(id: hy_ids)

    results.each do |result|
      kia_item = kia_items.select{|i| i.id == result['kia_id']}.first
      hy_item = hy_items.select{|i| i.id == result['hy_id']}.first
      kia_item.merge_item_into(hy_item)
    end
  end
end
