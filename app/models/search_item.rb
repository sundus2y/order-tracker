class SearchItem < ActiveRecord::Base

  def self.multiple_insert(list)
    delete_all
    values = list.map do |i|
      "('#{i['item_number']}','#{i['original_number']}','#{i['made']}','#{i['brand']}')"
    end.join(',')

    query = <<-SQL
INSERT INTO search_items (item_number, original_number, made, brand)
VALUES #{values}
    SQL

    self.connection.execute(query)
  end
end