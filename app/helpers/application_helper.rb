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
end
