namespace :reset do
  desc 'Resets Store Inventory'
  task store_inventory: :environment do
    ivs = Inventory.where(store_id: 10)
    t = Transfer.create(sender_id: 9, receiver_id: 9, from_store_id: 10, to_store_id: 7, note: 'Clearing Out Store')
    ivs.each do |iv|
      t.transfer_items.build(item_id: iv.item_id, qty: iv.qty) unless iv.qty == 0
    end
    t.save!
    t.reload
    t.submit!
    t.reload
    t.submit!
  end
end
