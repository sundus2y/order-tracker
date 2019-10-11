class User < ActiveRecord::Base
  devise :timeoutable
  enum role: [:user, :admin, :vendor, :supplier, :sales]
  after_initialize :set_defaults, :if => :new_record?

  has_many :sales, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :sent_transfers, dependent: :destroy, class_name: 'Transfer', foreign_key: :sender_id
  has_many :received_transfers, dependent: :destroy, class_name: 'Transfer', foreign_key: :receiver_id
  belongs_to :default_store, dependent: :destroy, class_name: 'Store', foreign_key: :default_store_id

  def set_defaults
    self.role ||= :user
    self.default_store_id ||= 14 #First Floor
  end

  def is_admin?
    role == 'admin'
  end

  def can_access_sale_record?(sale)
    self.is_admin? || (sale.store_id == self.default_store_id)
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :trackable, :validatable
end
