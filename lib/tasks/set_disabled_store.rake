namespace :set do
  desc "Set Active Store"
  task active_store: :environment do
    sql = <<-SQL
UPDATE stores SET active = FALSE WHERE id IN (4,5,6,9);
UPDATE stores SET active = TRUE WHERE id NOT IN (4,5,6,9)
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end
end
