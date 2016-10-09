namespace :set do
  desc "Set Sale Price"
  task sale_price: :environment do
    sql = <<-SQL
UPDATE items
SET sale_price = (CASE
                      WHEN dubai_price > 0
                        THEN (dubai_price + (dubai_price * 0.8)) * 6.04
                      WHEN korea_price > 0
                        THEN (korea_price + (korea_price * 0.8)) * 0.020
                      WHEN korea_price = 0 AND dubai_price = 0
                        THEN 0
                    END)
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
