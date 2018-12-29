namespace :reset do
  desc 'Resets Store Inventory'
  task store_inventory: :environment do
    id = ENV['ID']
    name  = ENV['NAME']
    short_name = ENV['SHORT_NAME']
    store = Store.where('id = ? or name = ? or short_name = ?', id, name, short_name)
    if store.count != 1
      raise 'Store not found' if store.count == 0
      raise 'Found more than one store' if store.count > 1
    end
    store = store.first
    raise "Can't Reset Virtual Store Inventory" if store.store_type == 'VS'
    ivs = Inventory.where(store: store)
    t = Transfer.create(sender_id: 9, receiver_id: 9, from_store: store, to_store_id: 7, note: 'Clearing Out Store')
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
