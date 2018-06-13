namespace :set do
  desc "Set Sales Tax"
  task sales_tax: :environment do
    progressbar = ProgressBar.create(:title => "Sales Update", :starting_at => 0, :total => Sale.count)
    Sale.includes(:sale_items).each do |s|
      s.sale_items.each do |si|
        si.unit_price = si.unit_price / 1.15
      end
      s.save
      progressbar.increment
    end
  end
end
