class ProformaItemsController < ApplicationController
  before_action :set_proforma_item, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!
  before_action :check_authorization
  after_action :verify_authorized


  respond_to :html

  def index
    @proforma_items = ProformaItem.all
    respond_with(@proforma_items)
  end

  def show
    respond_with(@proforma_item)
  end

  def new
    @proforma_item = ProformaItem.new
    respond_with(@proforma_item)
  end

  def edit
  end

  def create
    @proforma_item = ProformaItem.new(proforma_item_params)
    @proforma_item.save
    respond_to do |format|
      format.html {respond_with(@proforma_item,location: proforma_items_path)}
      format.json {render 'show'}
    end
  end

  def update
    @proforma_item.update(proforma_item_params)
    respond_to do |format|
      format.html {response_with(@proforma_item,location: proforma_items_path)}
      format.json {render 'show'}
    end
  end

  def destroy
    @proforma_item.destroy
    respond_to do |format|
      format.html {response_with(@proforma_item,location: proforma_items_path)}
      format.json {render 'show'}
    end
  end

  def by_store_and_item
    @proforma_items = ProformaItem.by_store_and_item(params[:store_id],params[:item_id])
  end

  private
    def set_proforma_item
      @proforma_item = ProformaItem.includes(:item).find(params[:id])
    end

    def proforma_item_params
      params.require(:proforma_item).permit(:proforma_id, :item_id, :qty, :unit_price)
    end

    def check_authorization
      authorize (@proforma_item || ProformaItem)
    end
end
