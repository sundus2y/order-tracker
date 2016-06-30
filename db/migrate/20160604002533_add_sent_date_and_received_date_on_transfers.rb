class AddSentDateAndReceivedDateOnTransfers < ActiveRecord::Migration
  def change
    add_column :transfers, :sent_date, :date
    add_column :transfers, :received_date, :date
  end
end
