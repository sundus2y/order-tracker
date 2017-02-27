class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!
  before_action :check_authorization
  after_action :verify_authorized

  respond_to :html

  def index
    @order_items = OrderItem.all
    respond_with(@order_items)
  end

  def show
    respond_with(@order_item)
  end

  def new
    @order_item = OrderItem.new
    respond_with(@order_item)
  end

  def edit
  end

  def create
    @order_item = OrderItem.new(order_item_params)
    flash[:notice] = 'OrderItem was successfully created.' if @order_item.save
    respond_with(@order_item)
  end

  def update
    flash[:notice] = 'OrderItem was successfully updated.' if @order_item.update(order_item_params)
    respond_to do |format|
      format.html {respond_with(@order_item,location: order_items_path)}
      format.js {render 'close_pop_up'}
    end
  end

  def destroy
    @order_item.destroy
    respond_to do |format|
      format.js
    end
  end

  def check_duplicate
    item_ids = params[:item_ids].split(',').map(&:to_i)
    order_id = params[:order_id].to_i
    found_order_items = OrderItem.find_duplicates(item_ids,params[:brand],order_id)
    if found_order_items.nil?
      data = []
    else
      data = found_order_items.map do |order_item|
        {
            order_id: order_item.order_id,
            item_name: order_item.item_name,
            url: edit_order_path(order_item.order)
        }
      end
    end
    respond_to do |format|
      format.json { render json: data}
    end
  end

  private
    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end

    def order_item_params
      params.require(:order_item).permit(:order_id, :item_name, :quantity, :brand)
    end

    def check_authorization
      authorize (@order_item || OrderItem)
    end
end
