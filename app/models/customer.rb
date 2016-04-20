class Customer < ActiveRecord::Base

  has_many :sales

  def display_text
    retval = name
    retval += " (#{company})" unless company.blank?
    retval += " (#{phone})" unless phone.blank?
    retval += " (#{tin_no})" unless tin_no.blank?
    retval
  end

end
