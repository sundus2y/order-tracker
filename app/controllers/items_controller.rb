class ItemsController < ApplicationController
  autocomplete :item, :name, :display_value => :to_s, :extra_data => [:item_number,:item_number,:description], :limit => 20
  autocomplete :item, :sale_price, :display_value => :sale_item_autocomplete_display, :extra_data => [:name,:item_number,:item_number,:description,:sale_price], :limit => 20
  autocomplete :item, :sale_order, :display_value => :sale_item_autocomplete_display, :extra_data => [:name,:item_number,:item_number,:description,:sale_price], :limit => 20

  before_action :set_empty_transaction
  before_action :set_item, only: [:show, :edit, :update, :destroy, :pop_up_show, :pop_up_edit, :copy]
  before_action :set_transaction_log, only: [:show, :edit, :pop_up_edit, :pop_up_show]

  before_filter :authenticate_user!
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
    render 'new'
  end

  def pop_up_edit
    render 'pop_up_edit', layout: false
  end

  def create
    @item = Item.new(item_params)
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
      @transactions = @item.transfer_log(@transactions)
      @transactions = @item.sales_order_log(@transactions)
      @transactions = @item.proforma_log(@transactions)
      @transactions.each{|k,v| v.sort_by!(&:created_at)}
    end
end
