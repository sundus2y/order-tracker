class Order < ActiveRecord::Base
  include AASM
  acts_as_paranoid

  scope :draft, lambda { where(status: 'draft') }
  scope :ordered, lambda { where(status: 'ordered') }
  scope :ready, lambda { where(status: 'ready') }
  scope :accepted, lambda { where(status: 'accepted') }
  scope :rejected, lambda { where(status: 'rejected') }
  scope :non_empty, lambda { where('order_items_count >= 1') }

  aasm :column => :status, :no_direct_assignment => true do
    state :draft, :initial => true
    state :ordered
    state :ready
    state :accepted
    state :rejected

    event :submit, after: :submit_order_items do
      transitions :from => :draft, :to => :ordered #ADMIN
      transitions :from => :ordered, :to => :ready #VENDOR
      transitions :from => :ready, :to => :ship #ADMIN
      transitions :from => :ship, :to => :shipped #VENDOR
      transitions :from => :shipped, :to => :received #ADMIN
    end

    event :reject, after: :reject_order_items do
      transitions :from => [:ordered,:ready,:ship,:shipped,:received], :to => :draft
    end
  end

  belongs_to :user
  has_many :order_items, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: lambda{|item_param| item_param[:qty].blank? }

  validates :title, presence: true

  def self.open_orders_count
    draft.count
  end

  def grand_total
    order_items.map(&:total_price).compact.sum
  end

  def total_qty
    order_items.map(&:qty).compact.sum
  end

  def status_upcase
    status.upcase
  end

  def status_class

  end

  def download
    workbook = WriteXLSX.new("tmp/Order ##{id}.xlsx")
    worksheet = workbook.add_worksheet
    heading_format = workbook.add_format(border: 6,bold: 1,color: 'red',align: 'left')
    table_heading_format = workbook.add_format(bold: 1)
    worksheet.merge_range('A1:B1',"Order ##{id} - #{title}", heading_format)
    worksheet.write(1,0,'No',table_heading_format)
    worksheet.write(1,1,'Item Name',table_heading_format)
    worksheet.write(1,2,'Original Number',table_heading_format)
    worksheet.write(1,3,'Description',table_heading_format)
    worksheet.write(1,4,'Qty',table_heading_format)
    worksheet.write(1,5,'Brand',table_heading_format)
    worksheet.write(1,6,'Dubai Price',table_heading_format)
    worksheet.write(1,7,'Korea Price',table_heading_format)
    worksheet.write(1,8,'Cost Price',table_heading_format)
    worksheet.write(1,9,'Sale Price',table_heading_format)
    worksheet.write(1,10,'C Price',table_heading_format)

    order_items.includes(:item).each_with_index do |order_item,index|
      worksheet.write(index+2,0,index+1)
      worksheet.write_string(index+2,1,order_item.item.name)
      worksheet.write_string(index+2,2,order_item.item.original_number)
      worksheet.write_string(index+2,3,order_item.item.description||'')
      worksheet.write(index+2,4,order_item.qty)
      worksheet.write(index+2,5,order_item.brand.try(:upcase)||'')
      worksheet.write(index+2,6,order_item.item.dubai_price)
      worksheet.write(index+2,7,order_item.item.korea_price)
      worksheet.write(index+2,8,order_item.item.cost_price)
      worksheet.write(index+2,9,order_item.item.sale_price)
      worksheet.write(index+2,10,order_item.item.c_price)
    end
    workbook.close
    File.open("tmp/Order ##{id}.xlsx").path
  end

  private
    def submit_order_items
      order_items.map(&:submit!)
    end

    def reject_order_items
      order_items.map(&:reject!)
    end
end
