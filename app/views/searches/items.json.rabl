object @results

attributes :current_page,:total_pages,:search_term
child(:data,{root: 'data'}) do
  extends('items/show')
end