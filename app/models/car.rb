class Car < ActiveRecord::Base
  belongs_to :customer
  has_many :proformas
  has_many :sales

  before_save :upcase_fields

  def upcase_fields
    self.vin_no.upcase!
    self.plate_no.upcase!
    self.year.upcase!
    self.model.upcase!
    self.brand.upcase!
  end
end
