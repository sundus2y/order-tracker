class Customer < ActiveRecord::Base
  enum category: [:retail, :wholesale, :company]

  has_many :sales

  def display_text
    retval = name
    retval += " (#{company})" unless company.blank?
    retval += " (#{phone})" unless phone.blank?
    retval += " (#{tin_no})" unless tin_no.blank?
    retval
  end

  def autocomplete_display
    str = "".html_safe
    str << "<div class='row'>".html_safe
    str << "<div class='col-md-3'>#{name}</div>".html_safe
    str << "<div class='col-md-3'>#{company.present? ? company : 'Unknown'}</div>".html_safe
    str << "<div class='col-md-2'>#{phone.present? ? phone : 'Unknown'}</div>".html_safe
    str << "<div class='col-md-2'>#{tin_no.present? ? tin_no : 'Unknown'}</div>".html_safe
    str << "<div class='col-md-2'>#{category}</div>".html_safe
    str << "</div>".html_safe
  end


end
