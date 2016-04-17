class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_orders, only:[:index, :show_all]

  before_filter :authenticate_user!
  before_action :check_authorization
  after_action :verify_authorized

  respond_to :html

  def index
    respond_with(@orders)
  end

  def show
    respond_with(@order)
  end

  def show_all
    respond_with(@orders)
  end

  def show_selected
    order_ids = params[:order_id].split(',').map(&:to_i)
    @orders = Order.where(id: order_ids)
    render "show_all" and return
  end

  def new
    @order = Order.new
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
    respond_to do |format|
      format.js
    end
  end

  def submit_to_ordered
    @order = Order.find(params[:order_id])
    @order.submit!
    respond_to do |format|
      format.js
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:title, :notes, :created_by, :status, :brand, order_items_attributes: [:id, :item_id, :quantity, :brand])
    end

    def set_orders
      order_policy = OrderPolicy.new(current_user,OrderPolicy)
      @orders = order_policy.resolve
    end

    def check_authorization
      authorize (@order || @orders || Order)
    end
end
