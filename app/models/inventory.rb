class Inventory < ActiveRecord::Base

  belongs_to :store
  belongs_to :item

  def update_location(loc)
    update_attribute(:location,loc)
  end

end