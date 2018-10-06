class Car < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :customer
  has_many :proformas
  has_many :sales

  before_save :upcase_fields

  def upcase_fields
    self.owner.upcase!
    self.vin_no.upcase!
    self.plate_no.upcase!
    self.year.upcase!
    self.model.upcase!
    self.brand.upcase!
  end
end
