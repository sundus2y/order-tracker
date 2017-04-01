class TransactionNumCounter < ActiveRecord::Base

  belongs_to :store

  def self.get_transaction_next_num_for(store_id)
    current = where(store_id: store_id).where("created_at >= ? and created_at <= ?",Time.zone.now.beginning_of_day,Time.zone.now.end_of_day).first
    unless current
      where(store_id: store_id).delete_all
      current = create(store_id: store_id, counter: 0)
    end
    current.counter += 1
    current.save
    current.counter
  end

end