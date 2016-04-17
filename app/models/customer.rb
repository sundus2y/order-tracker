class Customer < ActiveRecord::Base

  has_many :sales

  def display_text
    retval = name
    retval += " (#{company})" unless company.blank?
    retval
  end

end
