class SaleItemsController < ApplicationController
  before_action :set_sale_item, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!
  before_action :check_authorization
  after_action :verify_authorized


  respond_to :html

  def index
    @sale_items = SaleItem.all
    respond_with(@sale_items)
  end

  def show
    respond_with(@sale_item)
  end

  def new
    @sale_item = SaleItem.new
    respond_with(@sale_item)
  end

  def edit
  end

  def create
    @sale_item = SaleItem.new(sale_item_params)
    @sale_item.save
    respond_to do |format|
      format.html {respond_with(@sale_item,location: sale_items_path)}
      format.json {render json: @sale_item.as_json(SaleItem.json_options)}
    end
  end

  def update
    @sale_item.update(sale_item_params)
    respond_to do |format|
      format.html {response_with(@sale_item,location: sale_items_path)}
      format.json {render json: @sale_item.as_json(SaleItem.json_options)}
    end
  end

  def destroy
    @sale_item.destroy
    respond_to do |format|
      format.html {response_with(@sale_item,location: sale_items_path)}
      format.json {render json: @sale_item.as_json(SaleItem.json_options)}
    end
  end

  private
    def set_sale_item
      @sale_item = SaleItem.find(params[:id])
    end

    def sale_item_params
      params.require(:sale_item).permit(:sale_id, :item_id, :qty, :unit_price)
    end

    def check_authorization
      authorize (@sale_item || SaleItem)
    end
end
