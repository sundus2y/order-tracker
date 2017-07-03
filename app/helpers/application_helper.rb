module ApplicationHelper
  def link_to_add_fields(name, f, association)
    fields, id = empty_fields(f, association)
    link_to(name, '#', class: "add_fields btn btn-info btn-block",
            data: {id: id,
                   fields: fields.gsub("\n", "")},
            role: "button",
            disabled: true)
  end

  def empty_fields(f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render("#{association.to_s}/#{association.to_s.singularize}_fields", f: builder)
    end
    return fields, id
  end

  def link_span(name)
    content_tag(:span,name,class:"link-btn")
  end

  def navigation_li(link,label,options={})
    nav = "<li class='#{options[:klass]}' id='#{options[:id]}' data-parent='#{options[:parent]}'>"
    nav << "<a href='#{link}' data-method='#{options[:method]}' class='#{options[:klass]}'>"
    nav << "<i class='#{options[:icon]}'>"
    nav << "<div class='icon-bg bg-pink'></div>"
    nav << "</i>"
    nav << "<i class='fa fa-plus parent-plus'></i>" if options[:klass].try(:include?,'parent-menu')
    nav << "<span class='menu-title'>#{label}</span>"
    nav << "</a>"
    nav << "</li>"
    nav.html_safe
  end

  def actions(object)
    view_action = "<li><a class='btn-primary item-pop-up-menu' href='#{send(object.class.name.underscore+'_path', object)}'><i class='fa fa-eye'></i> View</a></li>"
    edit_action = "<li><a class='btn-primary item-pop-up-menu' href='#{send("edit_#{object.class.name.underscore}_path",object)}'><i class='fa fa-pencil'></i> Edit</a></li>"
    delete_action = "<li><a class='btn-danger item-pop-up-menu' href='#{send(object.class.name.underscore+'_path', object)}' data-confirm='Are you sure?' data-method='delete' rel='nofollow'><i class='fa fa-trash'></i> Delete</a></li>"
    actions = <<-HTML
      <div class="btn-group">
        <a class="btn btn-sm btn-primary dropdown-toggle" data-toggle="dropdown" href="#">
          Actions <span class="fa fa-caret-down" title="Toggle dropdown menu"></span>
        </a>
        <ul class="dropdown-menu context-menu">
          #{view_action}
          #{edit_action if policy(object).edit?}
          #{delete_action if policy(object).edit?}
        </ul>
      </div>
    HTML
    actions.html_safe
  end
end
