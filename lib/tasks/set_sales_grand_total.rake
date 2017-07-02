namespace :set do
  desc "Set Sales Grand Total"
  task sales_grand_total: :environment do
    progressbar = ProgressBar.create(:title => "Sales Update", :starting_at => 0, :total => Sale.count)
    Sale.includes(:sale_items).each do |s|
      progressbar.increment
      s.save
    end
  end
end
