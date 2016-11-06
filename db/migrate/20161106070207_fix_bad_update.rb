class FixBadUpdate < ActiveRecord::Migration
  def change
    dup_inventory = Inventory.select(:store_id,:item_id).group(:store_id,:item_id).having('count(*) > 1').to_a
    grouped_dups = Inventory.where(store_id: 8, item_id: dup_inventory.map(&:item_id)).group_by{|inv| [inv.store_id,inv.item_id]}
    grouped_dups.values.each do |invs|
      first = invs.shift
      invs.each do |inv|
        first.qty += inv.qty
        inv.delete
      end
      first.save
    end
    puts Inventory.select(:store_id,:item_id).group(:store_id,:item_id).having('count(*) > 1').to_a.count
  end
end
