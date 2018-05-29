object @proforma

attributes :id, :formatted_created_at, :formatted_updated_at, :formatted_sold_at ,:grand_total, :status_upcase, :transaction_num

child(:customer) { attributes :name }
child(:store) { attributes :name }

node(:proforma_items_count) { |proforma| proforma.proforma_items_count }
node(:can_edit) { |proforma| policy(proforma).edit? }
node(:can_submit) { |proforma| policy(proforma).submit_to_submitted? }
node(:can_mark_as_sold) { |proforma| policy(proforma).mark_as_sold? }
node(:can_print) { |proforma| policy(proforma).print? }
node(:can_delete) { |proforma| policy(proforma).destroy? }