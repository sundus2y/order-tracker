class ItemsController < ApplicationController
  autocomplete :item, :name, :display_value => :to_s, :extra_data => [:item_number,:item_number,:description], :limit => 20
  autocomplete :item, :sale_price, :display_value => :sale_item_autocomplete_display, :extra_data => [:name,:item_number,:item_number,:description,:sale_price], :limit => 20

  before_action :set_item, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!
  before_action :check_authorization
  after_action :verify_authorized

  respond_to :html

  def index
    @items = Item.all.includes(:sale_items,:order_items).order(:name).page(params[:page]).per_page(10)
    respond_with(@items)
  end

  def show
    set_transaction_log
    respond_with(@item)
  end

  def pop_up_show
    @item = Item.find(params[:item_id])
    set_transaction_log
    render 'pop_up_show', layout: false
  end

  def new
    @item = Item.new
    respond_with(@item)
  end

  def edit
    set_transaction_log
  end

  def pop_up_edit
    @item = Item.find(params[:item_id])
    set_transaction_log
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

  private
    def set_item
      @item = Item.find(params[:id])
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
      model = parameters[:model]
      limit = parameters[:options][:limit]
      data = parameters[:options][:extra_data]
      data << parameters[:method]
      model.where('LOWER(name) like LOWER(:term) or LOWER(item_number) like LOWER(:term)', term: "%#{parameters[:term]}%").limit(limit)
    end

    def check_authorization
      authorize @item || Item
    end

    def set_transaction_log
      @transactions = {}
      @transactions = @item.transfer_log(@transactions)
    end
end
