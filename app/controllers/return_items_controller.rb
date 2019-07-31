class ReturnItemsController < ApplicationController
  impressionist

  before_action :set_return_item, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!
  before_action :check_authorization
  after_action :verify_authorized

  respond_to :html

  def index
    @return_items = ReturnItem.all
    respond_with(@return_items)
  end

  def show
    respond_with(@return_item)
  end

  def new
    @return_item = ReturnItem.new
    respond_with(@return_item)
  end

  def edit
  end

  def create
    @return_item = ReturnItem.new(return_item_params)
    @return_item.save
    return_sale_item = SaleItem.find(return_item_params[:sale_item_id]).dup
    return_sale_item.qty = return_item_params[:qty].to_i
    return_sale_item.save
    return_sale_item.return_item!
    @return_item.sale_item.sale.return_sale! if @return_item.sale_item.sale.may_return_sale?
    respond_to do |format|
      format.html {respond_with(@return_item,location: return_items_path)}
      format.json {render json: @return_item.as_json()}
    end
  end

  def update
    @return_item.update(return_item_params)
    respond_with(@return_item)
  end

  def destroy
    @return_item.destroy
    respond_with(@return_item)
  end

  private
    def set_return_item
      @return_item = ReturnItem.find(params[:id])
    end

    def return_item_params
      params.require(:return_item).permit(:sale_item_id, :qty, :note)
    end

    def check_authorization
      authorize (@return_item || ReturnItem)
    end
end
