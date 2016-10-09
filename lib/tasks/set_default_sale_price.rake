namespace :set do
  desc "Set Default Sale Price"
  task default_sale_price: :environment do
    sql = <<-SQL
UPDATE items
SET default_sale_price = true
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
