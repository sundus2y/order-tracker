class TransferItem < ActiveRecord::Base

  belongs_to :transfer, :counter_cache => true
  belongs_to :item

  include AASM

  scope :draft, lambda { where(status: 'draft') }
  scope :sent, lambda { where(status: 'sent') }
  scope :received, lambda { where(status: 'received') }

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :sent
    state :received

    event :submit do
      transitions :from => :draft, :to => :sent, after: :dec_inventory #SALE
      transitions :from => :sent, :to => :received, after: :inc_inventory #SALE
    end

  end

  private

  def dec_inventory
    item.update_inventory(transfer.from_store,qty)
  end

  def inc_inventory
    item.update_inventory(transfer.to_store,qty,:up).update_location(location)
  end

  def self.import(file,transfer)
    workbook = Roo::Spreadsheet.open(file.path)
    raw_data = []
    error_list = []
    header = %w(item_number original_number made brand qty)
    header_hash = {}
    header.each{|k| header_hash[k] = k.titleize}
    sheets_count = workbook.sheets.count
    workbook.sheet(0).each_with_index(header_hash) do |hash, index|
      if index > 0
        begin
          new_item = {}
          new_item['item_number'] = hash['item_number'].to_s.gsub(INVALID_CHARS_REGEX, '').to_s.upcase
          new_item['original_number'] = hash['original_number'].to_s.gsub(INVALID_CHARS_REGEX, '').to_s.upcase
          new_item['made'] = hash['made'].to_s.upcase
          new_item['brand'] = hash['brand'].to_s.upcase
          new_item['qty'] = hash['qty']
          raw_data << new_item
        rescue Exception => e
          error_list << new_item
        end
      end
    end
    sql = []
    raw_data.each_with_index do |item|
      sql << "( item_number = '#{item['item_number']}' and
original_number = '#{item['original_number']}' and
made = '#{item['made']}' and
brand = '#{item['brand']}')"
    end
    items = Item.where(sql.join('or'))
    items.each do |item|
      raw_item = raw_data.select{ |i| item.item_number == i['item_number'] && item.original_number == i['original_number'] && item.made == i['made'] && item.brand == i['brand']}[0]
      transfer.transfer_items.build(item_id: item.id, qty: raw_item['qty'], location: '0')
    end
    transfer.save!
    return transfer.transfer_items, error_list
  end

end
