class ChangeSentDateAndReceivedDateToDateTime < ActiveRecord::Migration
  def change
    change_column :transfers, :sent_date, :datetime
    change_column :transfers, :received_date, :datetime
  end
end
