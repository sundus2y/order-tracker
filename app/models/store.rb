class Store < ActiveRecord::Base

  has_many :inventories, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :sent_transfers, dependent: :destroy, class_name: 'Transfer', foreign_key: :from_store_id
  has_many :received_transfers, dependent: :destroy, class_name: 'Transfer', foreign_key: :to_store_id

end