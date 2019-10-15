class ItemsController < ApplicationController
  impressionist actions: ItemsController.action_methods.to_a - ['autocomplete_item_name','autocomplete_item_sale_order','autocomplete_item_sale_price']

  autocomplete :item, :name, :display_value => :to_s, :extra_data => [:item_number,:item_number,:description], :limit => 20
  autocomplete :item, :sale_price, :display_value => :sale_item_autocomplete_display, :extra_data => [:name,:item_number,:item_number,:description,:sale_price], :limit => 20
  autocomplete :item, :sale_order, :display_value => :sale_item_autocomplete_display, :extra_data => [:name,:item_number,:item_number,:description,:sale_price], :limit => 20

  before_action :set_empty_transaction
  before_action :set_item, only: [:show, :edit, :update, :destroy, :pop_up_show, :pop_up_edit, :copy, :analysis_data]
  before_action :set_transaction_log, only: [:show, :edit, :update, :pop_up_edit, :pop_up_show, :new]
  before_action :set_related_items, only: [:show, :edit, :pop_up_edit, :pop_up_show]

  before_action :authenticate_user!
  before_action :check_authorization
  after_action :verify_authorized

  respond_to :html

  def index
    @items = Item.all.includes(:inventories).order(:name).page(params[:page]).per_page(10)
    respond_with(@items)
  end

  def show
    respond_with(@item)
  end

  def pop_up_show
    render 'pop_up_show', layout: false
  end

  def new
    @item = Item.new
    respond_with(@item)
  end

  def edit
  end

  def copy
    @item = @item.copy
    set_transaction_log
    render 'new'
  end

  def pop_up_edit
    render 'pop_up_edit', layout: false
  end

  def create
    @item = Item.new(item_params)
    set_transaction_log
    flash[:notice] = 'Item was successfully created.' if @item.save
    respond_to do |format|
      format.html {respond_with(@item,location: items_path)}
      format.js
    end
  end

  def update
    flash[:notice] = 'Item was successfully updated.' if @item.update(item_params)
    respond_to do |format|
      format.html {respond_with(@item,location: items_path)}
      format.js
    end
  end

  def destroy
    @item.destroy
    respond_with(@item)
  end

  def import
    return redirect_to request.referrer, notice: 'Please Select File First' unless params[:file]
    @duplicate_items, @items = Item.import(params[:file])
    flash[:notice] = 'All Items Imported Successfully' if @duplicate_items.empty?
    flash[:warning] = "Found #{@duplicate_items.count} Duplicate Items" unless @duplicate_items.empty?
  end

  def import_non_original
    return redirect_to request.referrer, notice: 'Please Select File First' unless params[:file]
    @created_items, @cloned_items, @error_items = Item.import_non_original(params[:file])
    flash[:notice] = 'All Items Imported Successfully' if @error_items.empty?
    flash[:warning] = "Found #{@error_items.count} Error Items" unless @error_items.empty?
  end

  def bulk_update
    return redirect_to request.referrer, notice: 'Please Select File First' unless params[:file]
    @updated_items, @error_items = Item.bulk_update(params[:file],params[:update_field])
    flash[:notice] = 'All Items where Updated Successfully' if @error_items.empty?
    flash[:warning] = "Found #{@error_items.count} Error Items" unless @error_items.empty?
  end

  def import_export
  end

  def download
    render html: '<div>Too Many Item to Download !!</div>'.html_safe
    # respond_to do |format|
    #   format.xlsx { send_file Item.download}
    # end
  end

  def download_inventory
    respond_to do |format|
      format.xlsx { send_file params[:store_id] ? Inventory.download_by_store(params[:store_id]) : Inventory.download}
    end
  end

  def template
    respond_to do |format|
      format.xlsx { send_file Item.template}
    end
  end

  def non_original_template
    respond_to do |format|
      format.xlsx { send_file Item.non_original_template}
    end
  end

  def bulk_update_template
    respond_to do |format|
      format.xlsx { send_file Item.bulk_update_template}
    end
  end

  def ip_xp
    item_number_list = []
    line_items = params['item_number_list'].split("\r\n")
    msg = "Please make sure the list is formatted as <b>'ItemNumber [space or tab] Brand'. <br> Submitted List:</b> <br>".html_safe +
        line_items.join('<br>'.html_safe).html_safe
    line_items.each do |v|
      row = v.split("\t")
      if row.count != 2
        row = v.split(" ")
        if row.count != 2
          return redirect_to request.referrer, notice: msg
        end
      end
      item_number_list << row
    end
    respond_to do |format|
      format.xlsx { send_file Item.ip_xp(item_number_list)}
    end
  end

  def analysis_data
    from = Time.zone.strptime(params[:date_from], '%m/%d/%Y')
    to = Time.zone.strptime(params[:date_to], '%m/%d/%Y')
    sale_items = @item.sale_items.joins(:sale).includes(:sale).where("sales.status = ? and sales.sold_at > ? and sales.sold_at < ?", 'sold', from, to).order("sales.sold_at").uniq
    if (to-from)/86400 > 120
      start_date = from.beginning_of_month
      end_date = to.end_of_month
      grouped_sale_items = {}
      while(start_date <= end_date) do
        grouped_sale_items[start_date] = sale_items.select{|si| si.sale.sold_at.beginning_of_month == start_date }
        start_date = start_date + 1.month
      end
    elsif (to-from)/86400 > 25
      start_date = from.beginning_of_week
      end_date = to.end_of_week
      grouped_sale_items = {}
      while(start_date <= end_date) do
        grouped_sale_items[start_date] = sale_items.select{|si| si.sale.sold_at.beginning_of_week == start_date }
        start_date = start_date + 1.week
      end
    else
      start_date = from.beginning_of_day
      end_date = to.end_of_day
      grouped_sale_items = {}
      while(start_date <= end_date) do
        grouped_sale_items[start_date] = sale_items.select{|si| si.sale.sold_at.beginning_of_day == start_date }
        start_date = start_date + 1.day
      end
    end
    grand_total = 0
    sales_data = grouped_sale_items.to_a.map do |grouped_sale_item|
      total_qty = grouped_sale_item[1].sum(&:qty)
      total_revenue = grouped_sale_item[1].inject(0) do |n,sale_item|
        n + sale_item.qty * sale_item.unit_price
      end
      store_inventory = @item.inventories.joins(:store).where("stores.store_type = 'ST'").map(&:paper_trail).map do |iv_v|
        iv_v.version_at(grouped_sale_item[0])
      end.sum(&:qty)
      shop_inventory = @item.inventories.joins(:store).where("stores.store_type = 'SH'").map(&:paper_trail).map do |iv_v|
        iv_v.version_at(grouped_sale_item[0])
      end.sum(&:qty)

      grand_total += total_revenue
      {
          date: grouped_sale_item[0],
          total_qty: total_qty,
          total_revenue: total_revenue * 1.15,
          average_price: (total_revenue * 1.15) / total_qty,
          shop_inventory: shop_inventory,
          store_inventory: store_inventory
      }
    end

    render json: {sales_data: sales_data, grand_total: grand_total}
  end

  private
    def set_item
      @item = Item.find(params[:id]||params[:item_id])
    end

    def item_params
      params.require(:item).permit(:name,
                                   :original_number,
                                   :item_number,
                                   :prev_number,
                                   :next_number,
                                   :size,
                                   :description,
                                   :car,
                                   :model,
                                   :make_from,
                                   :make_to,
                                   :sale_price,
                                   :dubai_price,
                                   :korea_price,
                                   :c_price,
                                   :hy_price,
                                   :kia_price,
                                   :part_class,
                                   :brand,
                                   :made,
                                   inventories_attributes: [:id, :qty, :location, :store_id])
    end

    def get_autocomplete_items(parameters)
      if parameters[:method] == :sale_order
        result = Item.autocomplete_for_sales(parameters[:term],parameters[:options][:limit])
        ActiveRecord::Associations::Preloader.new.preload(result, :inventories)
        result
      else
        model = parameters[:model]
        limit = parameters[:options][:limit]
        data = parameters[:options][:extra_data]
        data << parameters[:method]
        model.where('LOWER(name) like LOWER(:term) or LOWER(item_number) like LOWER(:term)', term: "%#{parameters[:term]}%").limit(limit)
      end
    end

    def check_authorization
      authorize @item || Item
    end

    def set_empty_transaction
      @transactions = {}
    end

    def set_transaction_log
      @transactions = @item.try(:transfer_log,@transactions) || @transactions
      @transactions = @item.try(:sales_order_log,@transactions) || @transactions
      @proforma_transactions = @item.try(:proforma_log) || []
      @transactions.each{|k,v| v.sort_by!(&:created_at)}
    end

    def set_related_items
      @related_items = Item.joins(:inventories, {inventories: :store})
                           .includes({inventories: :store}, :order_items, :proforma_items)
                           .where("stores.active = true AND stores.store_type != 'VS'")
                           .where(item_number: @item.related_item_numbers)
                           .where.not(id: @item.id)
                           .reorder(updated_at: :desc)
                           .limit(50)
    end
end
