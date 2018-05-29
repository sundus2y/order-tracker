class Transaction
  attr_accessor :in_qty, :out_qty, :transaction_type, :transaction_num, :created_at, :status, :label

  def initialize(transaction_num, transaction_type, in_qty, out_qty, created_at, status, label)
    @transaction_num = transaction_num
    @transaction_type = transaction_type
    @in_qty = in_qty
    @out_qty = out_qty
    @created_at = created_at
    @status = status
    @label = label
  end
end