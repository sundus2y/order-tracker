class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy]
  before_action :set_sales, only:[:index, :show_all]

  before_filter :authenticate_user!
  before_action :check_authorization, except: [:index, :new, :create, :submit_to_sold, :submit_to_credited, :submit_to_sampled, :mark_as_sold]
  after_action :verify_authorized

  respond_to :html

  def index
    @sales = Sale.where(store: Store.first)
    authorize @sales
    respond_with(@sales)
  end

  def show
    respond_with(@sale)
  end

  def sale_items
    @sale_items = Sale.includes(:sale_items).where(id: params[:sale_id]).first.sale_items
  end

  def new
    @sale = Sale.new(created_at:DateTime.now)
    authorize @sale
    respond_with(@sale)
  end

  def edit
  end

  def create
    @sale = Sale.new(sale_params)
    authorize @sale
    saved = @sale.save
    flash[:notice] = 'Sale Attachment was successfully created.' if saved
    respond_with(@sale,location: edit_sale_path(@sale)) if saved
    respond_with(@sale) unless saved
  end

  def update
    @sale.update(sale_params)
    if params[:submit]
      @sale.submit!
    elsif params[:credit]
      @sale.credit!
    elsif params[:sample]
      @sale.sample!
    end
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
    authorize @sale
    @sale.submit!
    render 'remove_draft_actions' and return
  end

  def mark_as_sold
    @sale = Sale.find(params[:sale_id])
    authorize @sale
    @sale.mark_as_sold!
    render 'remove_draft_actions' and return
  end

  def submit_to_credited
    @sale = Sale.find(params[:sale_id])
    authorize @sale
    @sale.credit!
    render 'remove_draft_actions' and return
  end

  def submit_to_sampled
    @sale = Sale.find(params[:sale_id])
    authorize @sale
    @sale.sample!
    render 'remove_draft_actions' and return
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
      params.require(:sale).permit(:customer_id, :store_id, :remark, :created_at)
    end

    def check_authorization
      authorize (@sale || @sales || Sale)
    end
end
