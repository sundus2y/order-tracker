class ItemsController < ApplicationController
  autocomplete :item, :name, :display_value => :to_s, :extra_data => [:item_number,:original_number,:description], :limit => 20

  before_filter :authenticate_user!
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :check_authorization, except: [:index, :new, :create]
  after_action :verify_authorized

  respond_to :html

  def index
    @items = Item.all.order(:name).page(params[:page]).per_page(10)
    authorize @items
    respond_with(@items)
  end

  def show
    respond_with(@item)
  end

  def new
    @item = Item.new
    authorize @item
    respond_with(@item)
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    authorize @item
    flash[:notice] = 'Item was successfully created.' if @item.save
    respond_to do |format|
      format.html {respond_with(@item,location: items_path)}
      format.js
    end
  end

  def update
    flash[:notice] = 'Item was successfully updated.' if @item.update(item_params)
    respond_with(@item,location: items_path)
  end

  def destroy
    @item.destroy
    respond_with(@item)
  end

  def import
    return redirect_to request.referrer, notice: "Please Select File First" unless params[:file]
    @duplicate_items, @items = Item.import(params[:file])
    flash[:notice] = "All Items Imported Successfully" if @duplicate_items.empty?
    flash[:warning] = "Found #{@duplicate_items.count} Duplicate Items" unless @duplicate_items.empty?
  end

  def import_export
  end

  def download
    respond_to do |format|
      format.xlsx { send_file Item.download}
    end
  end

  def template
    respond_to do |format|
      format.xlsx { send_file Item.excel_template}
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
                                   :description,
                                   :car,
                                   :model,
                                   :make_from,
                                   :make_to,
                                   :part_class,
                                   :brand,
                                   :made,
                                   :l_store,
                                   :t_shop,
                                   :l_shop)
    end

    def get_autocomplete_items(parameters)
      model = parameters[:model]
      limit = parameters[:options][:limit]
      data = parameters[:options][:extra_data]
      data << parameters[:method]
      model.where("LOWER(name) like LOWER(:term) or LOWER(item_number) like LOWER(:term) or LOWER(original_number) like LOWER(:term)", term: "%#{parameters[:term]}%").limit(limit)
    end

    def check_authorization
      authorize @item || Item
    end
end
