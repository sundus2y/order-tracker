class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]
  before_action :set_sales, only:[:index, :show_all]

  before_filter :authenticate_user!
  before_action :check_authorization
  after_action :verify_authorized

  respond_to :html

  def index
    @grouped_sales = Sale.all_grouped_by_store
    @stores = Sale.stores.keys
    respond_with(@sales)
  end

  def show
    respond_with(@sale)
  end

  def sale_items
    @sale = Sale.includes([{sale_items: [:item]}]).where(id: params[:id]).first
    respond_to do |format|
      format.json {render json: @sale.as_json(type: :sale_items) }
    end
  end

  def new
    @sale = Sale.new(created_at:DateTime.now)
    respond_with(@sale)
  end

  def edit
  end

  def create
    @sale = Sale.new(sale_params)
    @sale.save
    respond_with(@sale,location: edit_sale_path(@sale))
  end

  def update
    @sale.update(sale_params)
    respond_with(@sale,location: sales_path)
  end

  def destroy
    @sale.destroy
    respond_to do |format|
      format.js
    end
  end

  def submit_to_sold
    @sale = Sale.find(params[:sale_id])
    @sale.submit!
    respond_to do |format|
      format.js
    end
  end

  def stores
    respond_to do |format|
      format.json {render json: Sale.stores.to_a }
    end
  end

  private
    def set_sale
      @sale = Sale.find(params[:id])
    end

    def set_sales
      sale_policy = SalePolicy.new(current_user,SalePolicy,params)
      @sales = sale_policy.resolve
    end

    def sale_params
      params.require(:sale).permit(:customer_id, :store, :remark, :created_at)
    end


    def check_authorization
      authorize (@sale || @sales || Sale)
    end
end
