namespace :migrate do
  desc 'Migrate COL'
  task col: :environment do
    workbook = Roo::Spreadsheet.open("lib/tasks/#{ENV['FILE']}.xlsx")
    raw_data = []
    error_list = []
    header = %w(item_number name)
    header << ENV['COL']
    header_hash = {}
    header.each{|k|header_hash[k] = k.titleize}
    puts "Start Reading #{ENV['FILE']} File"
    workbook.sheet(0).each_with_index(header_hash) do |hash|
      begin
        hash['item_number'] = hash['item_number'].to_s.gsub(INVALID_CHARS_REGEX, '').to_s.upcase
        hash['name'] = hash['name'].to_s.upcase
        hash[ENV['COL']] = (hash[ENV['COL']] || 0).to_f
        raw_data << hash
      rescue Exception => e
        error_list << hash
      end
    end
    puts "Done Reading #{ENV['FILE']} File"

    progressbar = ProgressBar.create(title: "Migrate #{ENV['COL']} - Total", :starting_at => 0, :total => raw_data.in_groups_of(500).count, format: "%a %e %P% Processed: %c from %C")
    raw_data.in_groups_of(500).each_with_index do |raw_data_group,index|
      begin
        raw_data_group.compact!
        update_list = []
        new_list= []
        update_sql_result = ''
        insert_sql_result = ''
        select_sql = 'SELECT item_number FROM items WHERE item_number IN ('
        select_sql += raw_data_group.map{|data| "'#{data['item_number']}'" }.join(', ')
        select_sql += ')'
        result = ActiveRecord::Base.connection.execute(select_sql)
        item_numbers = result.map{|r| r.values}.flatten
        update_list, new_list = raw_data_group.partition{|data| item_numbers.include? data['item_number']}

        if new_list.count > 0
          new_sql = "INSERT INTO items (item_number, name, original_number, #{ENV['COL']}, brand, made) VALUES "
          new_sql += new_list.map do |new_item|
            "('#{new_item['item_number']}', #{ActiveRecord::Base.sanitize(new_item['name'])}, '#{new_item['item_number']}', '#{new_item[ENV['COL']]}', #{ENV['BRAND']}, 'KOREA')"
          end.join(', ')
          i_result = ActiveRecord::Base.connection.execute(new_sql)
          insert_sql_result = i_result.cmd_status
        end
        if update_list.count > 0
          update_sql = "UPDATE items AS i SET #{ENV['COL']} = u.#{ENV['COL']} FROM (values"
          update_sql += update_list.map do |update_item|
            "('#{update_item['item_number']}', #{update_item[ENV['COL']]})"
          end.join(', ')
          update_sql += ") AS u(item_number, #{ENV['COL']}) WHERE u.item_number = i.item_number"
          u_result = ActiveRecord::Base.connection.execute(update_sql)
          update_sql_result = u_result.cmd_status
        end
        puts "\nTotal - #{index+1} Data Processed: #{raw_data_group.count}"
        puts "Total - #{index+1} Items Updated: #{update_list.count} --> #{update_sql_result}"
        puts "Total - #{index+1} Items Created: #{new_list.count} --> #{insert_sql_result}"
        progressbar.increment
      rescue Exception => e
        progressbar.increment
        error_list << raw_data_group
      end
    end
    puts "Errors: #{error_list.count}"
    puts error_list.inspect
  end
end
