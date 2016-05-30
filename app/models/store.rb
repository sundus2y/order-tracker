class Store < ActiveRecord::Base

  has_many :inventories, dependent: :destroy
  has_many :sales, dependent: :destroy

end