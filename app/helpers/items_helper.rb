module ItemsHelper
  def listing_actions item
    actions = link_to 'Details', item, class: "btn btn-info actions", role:"button"
    actions << (link_to 'Edit', edit_item_path(item), class: "btn btn-success actions", role:"button")
    actions << (link_to 'Destroy', item, method: :delete, data: { confirm: 'Are you sure?' }, class: "btn btn-warning actions", role:"button")
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
end
