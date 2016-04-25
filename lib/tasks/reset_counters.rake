namespace :reset_counters do
  desc "Resets Counter Columns For Sales"
  task sales: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    Sale.find_each{|s| Sale.reset_counters(s.id,:sale_items)}
  end
end
