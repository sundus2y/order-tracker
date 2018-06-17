namespace :reset do
  desc "Reset Proforma Inventory"
  task proforma_inventory: :environment do
    progressbar = ProgressBar.create(:title => 'Proforma Update', :starting_at => 0, :total => Proforma.count)
    Proforma.joins(:proforma_items).includes(:proforma_items).where("proforma_items.created_at < '2018-06-15' and proforma_items.status != 'sold' and qty > 1").each do |p|
      if p.status == 'sold'
        p.proforma_items.each do |pi|
          pi.qty = -1 * pi.qty if pi.qty < 0
          pi.save!
        end
      elsif p.status == 'submitted'
        p.proforma_items.each do |pi|
          iv = pi.item.inventories.where(store: p.store).first
          iv.qty += (pi.qty)-1
          iv.save!
        end
      end
      p.save
      progressbar.increment
    end
  end
end
