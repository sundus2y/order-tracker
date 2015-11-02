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
end
