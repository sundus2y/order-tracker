class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  respond_to :html

  def index
    @orders = Order.all
    respond_with(@orders)
  end

  def show
    respond_with(@order)
  end

  def new
    @order = Order.new
    authorize @order
    respond_with(@order)
  end

  def edit
  end

  def create
    @order = Order.new(order_params)
    flash[:notice] = 'Order was successfully created.' if @order.save
    respond_with(@order,location:orders_path)
  end

  def update
    flash[:notice] = 'Order was successfully updated.' if @order.update(order_params)
    respond_with(@order,location:edit_order_path)
  end

  def destroy
    @order.destroy
    respond_with(@order,location:orders_path)
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:title, :notes, :created_by, :status, order_items_attributes: [:id, :item_id, :quantity, :brand])
    end
end
