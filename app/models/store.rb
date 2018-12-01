class Store < ActiveRecord::Base
  acts_as_paranoid

  has_many :inventories, dependent: :destroy
  has_many :sales, dependent: :destroy
  has_many :sent_transfers, dependent: :destroy, class_name: 'Transfer', foreign_key: :from_store_id
  has_many :received_transfers, dependent: :destroy, class_name: 'Transfer', foreign_key: :to_store_id
  has_many :users, dependent: :destroy

  scope :for_sales, -> { where.not(store_type: ['VS','ST'], active: false) }
  scope :minus_virtual, -> { where.not(store_type: ['VS'], active: false) }
  scope :active, -> { where(active: true) }

  def virtual?
    store_type == 'VS'
  end

  def self.for_sales_by_user(user)
    return for_sales if user.is_admin?
    [user.default_store]
  end

end