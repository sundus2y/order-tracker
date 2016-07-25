class TransactionNumCounter < ActiveRecord::Base

  belongs_to :store

  def self.get_transaction_next_num_for(store_id)
    current = where(store_id: store_id).where("created_at <=  '#{DateTime.now.strftime('%Y-%m-%d')}'::date + '1 day'::interval").first
    unless current
      current = create(store_id: store_id, counter: 0)
    end
    current.counter += 1
    current.save
    current.counter
  end

end