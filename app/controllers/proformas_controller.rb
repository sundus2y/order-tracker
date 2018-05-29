class ProformasController < ApplicationController
  before_action :set_proforma, only: [:show, :edit, :update, :destroy, :print]

  before_filter :authenticate_user!
  before_action :check_authorization, except: [:index, :new, :create, :submit_to_submitted, :mark_as_sold]
  after_action :verify_authorized

  respond_to :html

  def index
    @proformas = Proforma.where(store: Store.first)
    authorize @proformas
    respond_with(@proformas)
  end

  def show
    respond_with(@proforma)
  end

  def proforma_items
    @proforma_items = ProformaItem.where(proforma_id: params[:proforma_id])
  end

  def new
    @proforma = Proforma.new(created_at:DateTime.now)
    authorize @proforma
    respond_with(@proforma)
  end

  def edit
  end

  def create
    @proforma = Proforma.new(proforma_params.merge({creator_id: current_user.id}))
    authorize @proforma
    if @proforma.save
      flash[:notice] = 'Proforma was successfully created.'
      respond_with(@proforma,location: edit_proforma_path(@proforma))
    else
      respond_with(@proforma)
    end
  end

  def update
    flash[:notice] = 'Proforma was successfully updated.' if @proforma.update(proforma_params)
    respond_to do |format|
      format.html {respond_with(@proforma,location: proformas_path)}
      format.js {render 'close_pop_up'}
    end
  end

  def destroy
    @proforma.delete_draft!
    respond_to do |format|
      format.js {render 'reload_search' and return}
    end
  end

  def submit_to_submitted
    @proforma = Proforma.find(params[:proforma_id])
    authorize @proforma
    @proforma.submit!
    respond_to do |format|
      format.html {redirect_to(proforma_path @proforma)}
      format.js {render 'reload_search' and return}
    end
  end

  def print
    render 'print', layout: 'print'
  end

  def mark_as_sold
    @proforma = Proforma.find(params[:proforma_id])
    authorize @proforma
    @proforma.mark_as_sold!({current_user_id: current_user.id})
    respond_to do |format|
      format.html {redirect_to(edit_sale_path @proforma.sale)}
      format.js {render 'reload_search' and return}
    end
  end

  private
    def set_proforma
      @proforma = Proforma.find(params[:id]||params[:proforma_id])
    end

    def set_proformas
      proforma_policy = ProformaPolicy.new(current_user,ProformaPolicy,params)
      @proformas = proforma_policy.resolve
    end

    def proforma_params
      params.require(:proforma).permit(:customer_id, :car_id, :store_id, :remark)
    end

    def check_authorization
      authorize (@proforma || @proformas || Proforma)
    end
end
