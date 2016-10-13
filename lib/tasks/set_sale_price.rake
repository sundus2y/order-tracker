namespace :set do
  desc "Set Sale Price"
  task sale_price: :environment do
    sql = <<-SQL
UPDATE items
SET sale_price = (CASE
                      WHEN dubai_price > 0
                        THEN (dubai_price * 0.27) * 80
                      WHEN korea_price > 0
                        THEN (korea_price * 0.00088) * 80
                      WHEN korea_price = 0 AND dubai_price = 0
                        THEN 0
                    END)
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
