namespace :cleanup do
  desc "Cleanup Sampled Sales"
  task sampled_sales: :environment do
    sampled_sales = Sale.sampled
    sampled_sales.each do |sampled_sale|
      print sampled_sale.id
      if sampled_sale.may_mark_as_sold?
        sampled_sale.mark_as_sold!
        puts ' Marked as Sold'
      elsif sampled_sale.may_return_sale?
        sampled_sale.return_sale!
        puts ' Marked as Returned'
      end
    end
  end

  task credited_sales: :environment do
    credited_sales = Sale.credited
    credited_sales.each do |credited_sale|
      print credited_sale.id
      if credited_sale.may_mark_as_sold?
        credited_sale.mark_as_sold!
        puts ' Marked as Sold'
      elsif credited_sale.may_return_sale?
        credited_sale.return_sale!
        puts ' Marked as Returned'
      end
    end
  end
end
