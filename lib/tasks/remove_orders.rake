namespace :remove do
  desc 'Migrate COL'
  task orders: :environment do
    order_ids = ENV['ORDERS'].split(',').map(&:to_i)
    orders = Order.unscoped.where(id: order_ids)
    puts "Removing #{orders.count} Orders"
    puts "#{order_ids.count} IDS requested: #{order_ids.sort}"
    puts "#{orders.count} IDS found:        #{orders.map(&:id).sort}"
    orders.map(&:destroy)
  end
end
