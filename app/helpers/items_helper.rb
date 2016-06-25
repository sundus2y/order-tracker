module ItemsHelper

  def importing_actions item
    actions = link_to "Create",
    actions
  end

  def line_number(index,current_page=nil)
    return index+1 if current_page.nil?
    (10*current_page.to_i) + index - 9
  end

  def description_formatter(desc)
    desc.to_s.gsub("\n",'<br />').html_safe
  end
end
