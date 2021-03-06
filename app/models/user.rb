class User < ActiveRecord::Base
  enum role: [:user, :admin, :vendor, :supplier]
  after_initialize :set_default_role, :if => :new_record?
  has_many :orders, dependent: :destroy

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
        :trackable, :validatable
end
