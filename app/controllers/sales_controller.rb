class SalesController < ApplicationController
  impressionist

  before_action :set_sale, only: [:show, :edit, :update, :destroy,
                                  :print, :pop_up_fs_num_edit, :mark_as_sold,
                                  :submit_to_sold, :submit_to_credited, :submit_to_sampled, :submit_to_ordered]

  before_filter :authenticate_user!
  before_action :check_authorization, except: [:index, :new, :create]
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

  def pop_up_fs_num_edit
    render 'pop_up_fs_num_edit', layout: false
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
    flash[:notice] = 'Sales was successfully updated.' if @sale.update(sale_params)
    respond_to do |format|
      format.html {respond_with(@sale,location: sales_path)}
      format.js {render 'close_pop_up'}
    end
  end

  def destroy
    @sale.delete_draft!
    respond_to do |format|
      format.js {render 'reload_search' and return}
    end
  end

  def submit_to_sold
    @sale.update(sale_params)
    @sale.submit!
    respond_to do |format|
      format.html {redirect_to(sale_path @sale)}
      format.js {render 'reload_search' and return}
    end
  end

  def submit_to_ordered
    @sale.update(sale_params)
    @sale.submit_to_ordered!
    respond_to do |format|
      format.html {redirect_to(sale_path @sale)}
    end
  end

  def print
    render 'print', layout: 'print'
  end

  def mark_as_sold
    @sale.update(sale_params)
    @sale.mark_as_sold!
    respond_to do |format|
      format.html {redirect_to(sale_path @sale)}
      format.js {render 'reload_search' and return}
    end
  end

  def submit_to_credited
    @sale.update(sale_params)
    @sale.credit!
    respond_to do |format|
      format.html {redirect_to(sale_path @sale)}
      format.js {render 'reload_search' and return}
    end
  end

  def submit_to_sampled
    @sale.update(sale_params)
    @sale.sample!
    respond_to do |format|
      format.html {redirect_to(sale_path @sale)}
      format.js {render 'reload_search' and return}
    end
  end

  private
    def set_sale
      @sale = Sale.find(params[:id]||params[:sale_id])
    end

    def set_sales
      sale_policy = SalePolicy.new(current_user,SalePolicy,params)
      @sales = sale_policy.resolve
    end

    def sale_params
      return {} if params[:sale].nil?
      params.require(:sale).permit(:customer_id, :car_id, :store_id, :remark, :fs_num, :delivery_date, :down_payment)
    end

    def check_authorization
      authorize (@sale || @sales || Sale)
    end
end
