module ItemsHelper
  def listing_actions item
    actions = link_to '', item, class: "btn btn-info btn-sm glyphicon glyphicon-eye-open action", role:"button"
    actions << '<br>'.html_safe
    actions << (link_to '', edit_item_path(item), class: "btn btn-success btn-sm glyphicon glyphicon-pencil", role:"button")
    actions << '<br>'.html_safe
    actions << (link_to '', item, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-warning btn-sm glyphicon glyphicon-trash", role:"button")
    actions
  end

  def importing_actions item
    actions = link_to "Create",
    actions
  end

  def line_number(index,current_page=nil)
    return index+1 if current_page.nil?
    (10*current_page.to_i) + index - 9
  end

  def description_formatter(desc)
    desc.gsub("\n",'<br />').html_safe
  end
end
