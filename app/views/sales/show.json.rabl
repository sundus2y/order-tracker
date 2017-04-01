object @sale

attributes :id, :formatted_created_at, :grand_total, :status_upcase, :transaction_num

child(:customer) { attributes :name }

node(:sale_items_count) { |sale| sale.sale_items.count }
node(:can_edit) { |sale| policy(sale).edit? }
node(:can_submit) { |sale| policy(sale).submit_to_sold? }
node(:can_mark_as_sold) { |sale| policy(sale).mark_as_sold? }
node(:can_credit) { |sale| policy(sale).submit_to_credited? }
node(:can_sample) { |sale| policy(sale).submit_to_sampled? }
node(:can_delete) { |sale| policy(sale).destroy? }