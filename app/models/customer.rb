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
    str << "<div data-index='0'>#{name}</div>".html_safe
    str << "<div data-index='1'>#{company.present? ? company : 'Unknown'}</div>".html_safe
    str << "<div data-index='2'>#{phone.present? ? phone : 'Unknown'}</div>".html_safe
    str << "<div data-index='3'>#{tin_no.present? ? tin_no : 'Unknown'}</div>".html_safe
    str << "<div data-index='4'>#{category}</div>".html_safe
    str << "</div>".html_safe
  end

  def label
    name
  end

end
