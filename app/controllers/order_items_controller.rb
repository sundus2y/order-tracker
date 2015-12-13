class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!
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
    respond_with(@order_item)
  end

  def destroy
    @order_item.destroy
    respond_to do |format|
      format.js
    end
  end

  def check_duplicate
    found_order_item = OrderItem.find_duplicate(params[:item_id].to_i)
    if found_order_item.nil?
      data = {}
    else
      item_id = found_order_item.item_id
      url = edit_order_path(found_order_item.order)
      data = {:"#{item_id}"=>{id:found_order_item.order.id,url:url}}
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
      params.require(:order_item).permit(:order_id, :item_name, :quantity)
    end
end
