namespace :cleanup do
  desc "Cleanup customer table"
  task customer_table: :environment do
    sql = <<-SQL
UPDATE customers
SET name = UPPER(name), company = UPPER(company)
    SQL
    ActiveRecord::Base.connection.execute(sql)

    sql = <<-SQL
UPDATE customers
SET name = trim(trailing ' ' from trim(trailing '[]' from name)),
company = trim(trailing ' ' from trim(trailing '[]' from company))
    SQL
    ActiveRecord::Base.connection.execute(sql)

    # STDOUT.puts 'Cleaning up duplicate customers'
    # list = {}
    # dup_customers = Customer.all.select('name, tin_no').group(:name,:tin_no).having('count(id) > 1')
    # dup_customers.each do |dup_customer|
    #   list["#{dup_customer.name}-#{dup_customer.tin_no}"] = []
    #   customers = Customer.includes(:sales).where(name: dup_customer.name, tin_no: dup_customer.tin_no)
    #   customers.each do |customer|
    #     list["#{dup_customer.name}-#{dup_customer.tin_no}"] << [customer.id, customer.sales.count]
    #   end
    # end

  end
end
