class OrdersController < ApplicationController
  impressionist

  before_action :set_order, only: [:show, :edit, :update, :destroy, :download]
  before_action :set_orders, only:[:index, :show_all]

  before_action :authenticate_user!
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
    @order = Order.new(order_params.merge({creator_id: current_user.id}))
    flash[:notice] = 'Order was successfully created.' if @order.save
    respond_to do |format|
      format.html {respond_with(@order,location: orders_path)}
      format.js {render 'close_pop_up'}
    end
  end

  def update
    flash[:notice] = 'Order was successfully updated.' if @order.update(order_params)
    respond_to do |format|
      format.html {respond_with(@order,location: orders_path)}
      format.js {render 'close_pop_up'}
    end
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

  def pop_up_add_item
    item = Item.active.find(params[:item_id])
    @original_item = Item.active.where(original_number: item.original_number).first
    @original_item = item if item.original_number == 'NA'
    @order_items = OrderItem.includes(:order).where(item: @original_item).where.not(status: 'delivered').order(updated_at: :desc)
    @open_orders = Order.where(status: 'draft')
    @new_order = Order.new()
    @new_order_item = OrderItem.new()
    render 'pop_up_add_item', layout: false
  end

  def download
    respond_to do |format|
      format.xlsx { send_file @order.download}
    end
  end

  private
    def set_order
      @order = Order.includes(order_items: :item).where(id: params[:id]).first
    end

    def order_params
      params.require(:order).permit(:title, :notes, :creator_id, :status, :brand, order_items_attributes: [:id, :item_id, :qty, :brand])
    end

    def set_orders
      order_policy = OrderPolicy.new(current_user,OrderPolicy)
      @orders = order_policy.resolve
    end

    def check_authorization
      authorize (@order || @orders || Order)
    end
end
