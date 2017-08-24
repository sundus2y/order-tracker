module Stats
  module Customer
    def self.top_5
      ::Customer.connection.execute(
          <<SQL
        SELECT name, count(sales.id) as ct, sum(sales.grand_total) as gt 
FROM "customers" INNER JOIN "sales" ON "sales"."customer_id" = "customers"."id"
WHERE sales.status = 'sold' AND name <> 'Cash' 
GROUP BY name  
ORDER BY gt desc
LIMIT 5
SQL
      )
    end
  end
end