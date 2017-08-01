module Stats
  module Sale
    def self.top_10_sales
      ::Sale.sold.order('grand_total desc').limit(10)
    end

    def self.monthly_sales
      ::Sale.sold.current_year.group("date_trunc('month', sold_at)").order('date_trunc_month_sold_at').sum(:grand_total).to_a
      # ::Sale.sold.group("date_part('week', updated_at)").order('date_part_week_updated_at').sum(:grand_total).to_a
    end

    def self.this_week_sales
      ::Sale.sold.where(sold_at: [Time.zone.now.beginning_of_week..Time.zone.now.end_of_week]).sum(:grand_total)
    end

    def self.weekly_sales_change
      last_week = ::Sale.sold.where(sold_at: [1.week.ago.beginning_of_week..1.week.ago]).sum(:grand_total)
      this_week = ::Sale.sold.where(sold_at: [Time.zone.now.beginning_of_week..Time.zone.now]).sum(:grand_total)
      last_week.to_i != 0 ? ((this_week - last_week)/last_week*100) : 0
    end

    def self.daily_customers
      ::Sale.sold.where(sold_at: [Time.zone.now.beginning_of_day..Time.zone.now.end_of_day]).distinct.count(:customer_id)
    end

    def self.daily_sold
      ::Sale.sold.where(sold_at: [Time.zone.now.beginning_of_day..Time.zone.now.end_of_day])
    end

    def self.daily_sold_amount
      self.daily_sold.sum(:grand_total)
    end

    def self.daily_sold_count
      self.daily_sold.count
    end

    def self.daily_credited
      ::Sale.credited.where(updated_at: [Time.zone.now.beginning_of_day..Time.zone.now.end_of_day])
    end

    def self.daily_credited_amount
      self.daily_credited.sum(:grand_total)
    end

    def self.daily_credited_count
      self.daily_credited.count
    end

    def self.daily_sampled
      ::Sale.sampled.where(updated_at: [Time.zone.now.beginning_of_day..Time.zone.now.end_of_day])
    end

    def self.daily_sampled_amount
      self.daily_sampled.sum(:grand_total)
    end

    def self.daily_sampled_count
      self.daily_sampled.count
    end

    def self.daily_draft
      ::Sale.draft.where(updated_at: [Time.zone.now.beginning_of_day..Time.zone.now.end_of_day])
    end

    def self.daily_draft_amount
      self.daily_drfat.sum(:grand_total)
    end

    def self.daily_draft_count
      self.daily_draft.count
    end

    def self.all_time_credited
      ::Sale.includes(:customer).credited.order('created_at')
    end

    def self.all_time_sampled
      ::Sale.includes(:customer).sampled.order('created_at')
    end

    def self.monthly_revenue
      ::Sale.sold.joins(:sale_items,{sale_items: :item}).where(sold_at: [Time.zone.now.beginning_of_month..Time.zone.now.end_of_month]).where.not(items: {cost_price: nil}).sum(:grand_total)
    end

    def self.monthly_revenue_change
      last_month = ::Sale.sold.joins(:sale_items,{sale_items: :item}).where(sold_at: [1.month.ago.beginning_of_month..1.month.ago]).where.not(items: {cost_price: nil}).sum(:grand_total)
      this_week = ::Sale.sold.where(sold_at: [Time.zone.now.beginning_of_week..Time.zone.now]).sum(:grand_total)
      last_week.to_i != 0 ? ((this_week - last_week)/last_week*100) : 0
    end

    def self.monthly_cost
      ::Sale.sold.joins(:sale_items,{sale_items: :item}).where(sold_at: [Time.zone.now.beginning_of_month..Time.zone.now.end_of_month]).where.not(items: {cost_price: nil}).sum(:cost_price)
    end

  end
end