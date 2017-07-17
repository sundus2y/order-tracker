namespace :set do
  desc "Set Sold At for Sales"
  task sold_at: :environment do
    sql = <<-SQL
UPDATE sales
SET sold_at = updated_at
WHERE status = 'sold'
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
