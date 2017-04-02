class SalesController < ApplicationController
  before_action :set_sale, only: [:show, :edit, :update, :destroy, :print]

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
    @sale = Sale.new(sale_params.merge({creator_id: current_user.id}))
    authorize @sale
    if @sale.save
      flash[:notice] = 'Sale Order was successfully created.'
      respond_with(@sale,location: edit_sale_path(@sale))
    else
      respond_with(@sale)
    end
  end

  def update
    @sale.update(sale_params)
    respond_with(@sale,location: sales_path)
  end

  def destroy
    @sale.destroy
  end

  def submit_to_sold
    @sale = Sale.find(params[:sale_id])
    authorize @sale
    @sale.submit!
    respond_to do |format|
      format.html {redirect_to(sale_path @sale)}
      format.js {render 'remove_draft_actions' and return}
    end
  end

  def print
    render 'print', layout: 'print'
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
    respond_to do |format|
      format.html {redirect_to(sale_path @sale)}
      format.js {render 'remove_draft_actions' and return}
    end
  end

  def submit_to_sampled
    @sale = Sale.find(params[:sale_id])
    authorize @sale
    @sale.sample!
    respond_to do |format|
      format.html {redirect_to(sale_path @sale)}
      format.js {render 'remove_draft_actions' and return}
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
      params.require(:sale).permit(:customer_id, :store_id, :remark)
    end

    def check_authorization
      authorize (@sale || @sales || Sale)
    end
end
