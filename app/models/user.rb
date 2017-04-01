class User < ActiveRecord::Base
  devise :timeoutable
  enum role: [:user, :admin, :vendor, :supplier, :sales]
  after_initialize :set_default_role, :if => :new_record?

  has_many :orders, dependent: :destroy
  has_many :sent_transfers, dependent: :destroy, class_name: 'Transfer', foreign_key: :sender_id
  has_many :received_transfers, dependent: :destroy, class_name: 'Transfer', foreign_key: :receiver_id
  belongs_to :default_store, dependent: :destroy, class_name: 'Store', foreign_key: :default_store_id

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :trackable, :validatable
end
