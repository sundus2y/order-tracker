namespace :reset do
  desc "Reset Proforma Inventory"
  task proforma_inventory: :environment do
    progressbar = ProgressBar.create(:title => 'Proforma Update', :starting_at => 0, :total => Proforma.count)
    Proforma.includes(:proforma_items).each do |p|
      if p.status == 'sold'
        p.proforma_items.each do |pi|
          pi.qty = -1 * pi.qty if pi.qty < 0
        end
      elsif p.status == 'submitted'
        p.proforma_items.each do |pi|
          iv = pi.item.inventories.where(store: p.store).first
          iv.qty += 1
          iv.save!
        end
      end
      p.save
      progressbar.increment
    end
  end
end
