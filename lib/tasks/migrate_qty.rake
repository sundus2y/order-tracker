namespace :migrate do
  desc "Resets Counter Columns For Sales"
  task qty: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    t_shop = Item.where.not(t_shop: 0)
    l_shop = Item.where.not(l_shop: 0)
    l_store = Item.where.not(l_store: 0)
    ts = Store.create(name:'Teklehimanot Shop', short_name:'T-Shop')
    ls = Store.create(name:'Lem Hotel Shop', short_name:'L-Shop')
    ls2 = Store.create(name:'Lem Hotel Store', short_name:'L-Store')
    t_shop.each{|item| item.inventories.create(store:ts,qty:item.t_shop)}
    l_shop.each{|item| item.inventories.create(store:ls,qty:item.l_shop)}
    l_store.each{|item| item.inventories.create(store:ls2,qty:item.l_store)}
  end
end
