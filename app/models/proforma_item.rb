class ProformaItem < ActiveRecord::Base

  belongs_to :proforma, :counter_cache => true
  belongs_to :item

  before_create :set_unit_price
  after_save :recal_grand_total

  validates_presence_of :item_id, :proforma_id

  include AASM

  scope :draft, lambda { where(status: 'draft') }
  scope :submitted, lambda { where(status: 'submitted') }
  scope :sold, lambda { where(status: 'sold') }
  scope :void, lambda { where(status: 'void') }
  scope :current_year, lambda {where("created_at > '#{Time.zone.now.beginning_of_year}'")}

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :submitted
    state :sold
    state :void

    event :submit, after: :submit_proforma_items do
      transitions :from => :draft, :to => :submitted
    end

    event :mark_as_sold, after: :mark_as_sold_items do
      transitions :from => :submitted, :to => :sold #SALE
    end

    event :reject, after: :reject_proforma_items do
      transitions :from => [:sold,:draft,:submitted], :to => :void #ADMIN
    end
  end

  def self.by_store_and_item(store_id,item_id)
    includes(:proforma,:item,{proforma:[:customer]}).
        where(proformas:{store_id:store_id},item_id:item_id,status: %w(submitted))
  end

  private
    def set_unit_price
      self.unit_price = item.sale_price if unit_price.nil? || unit_price == 0
    end

    def recal_grand_total
      proforma.reload.save!
    end

end
