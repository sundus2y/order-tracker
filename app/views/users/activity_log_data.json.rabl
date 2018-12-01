object @user

attributes :id, :formatted_created_at, :formatted_updated_at, :formatted_sold_at ,:grand_total, :status_upcase, :transaction_num, :fs_num

child(:customer) { attributes :name }
child(:store) { attributes :name }

node(:sale_items_count) { |sale| sale.sale_items_count }
node(:can_edit) { |sale| policy(sale).edit? }
node(:can_submit) { |sale| policy(sale).submit_to_sold? }
node(:can_mark_as_sold) { |sale| policy(sale).mark_as_sold? }
node(:can_credit) { |sale| policy(sale).submit_to_credited? }
node(:can_sample) { |sale| policy(sale).submit_to_sampled? }
node(:can_print) { |sale| policy(sale).print? }
node(:can_delete) { |sale| policy(sale).destroy? }
node(:can_edit_fs_num) { |sale| policy(sale).pop_up_fs_num_edit? }