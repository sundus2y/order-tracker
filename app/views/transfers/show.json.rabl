object @transfer

attributes :id, :status_upcase

child(from_store: :from_store) { attributes :id, :name }
child(to_store: :to_store) { attributes :id, :name }
child(sender: :sender) { attributes :id, :name }
child(receiver: :receiver) { attributes :id, :name }
node(:transfer_items_count) {|transfer| transfer.transfer_items.count }

node(:can_edit) { |transfer| policy(transfer).edit? }
node(:can_transfer) {|transfer| policy(transfer).transfer? }
node(:can_receive) {|transfer| policy(transfer).receive? }

