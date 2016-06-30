class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :edit, :update, :destroy]
  before_action :set_transfers, only:[:index, :show_all]

  before_filter :authenticate_user!
  before_action :check_authorization, except: [:submit,:create]
  after_action :verify_authorized

  respond_to :html

  def index
    @transfers = Transfer.all
    respond_with(@transfers)
  end

  def show
    respond_with(@transfer)
  end

  def transfer_items
    @transfer_items = Transfer.includes(:transfer_items).where(id: params[:transfer_id]).first.transfer_items
  end

  def new
    @transfer = Transfer.new
    respond_with(@transfer)
  end

  def edit
  end

  def create
    @transfer = Transfer.new(transfer_params.merge({sender_id: current_user.id}))
    authorize @transfer
    if @transfer.save
      flash[:notice] = 'Transfer was successfully created.'
      respond_with(@transfer,location: edit_transfer_path(@transfer))
    else
      respond_with(@transfer)
    end
  end

  def update
    flash[:notice] = 'Transfer was successfully updated.' if @transfer.update(transfer_params)
    respond_with(@transfer,location: transfers_path)
  end

  def destroy
    @transfer.destroy
    respond_with(@transfer)
  end

  def submit
    @transfer = Transfer.find(params[:transfer_id])
    authorize @transfer
    @transfer.submit!
    respond_to do |format|
      format.html {redirect_to(transfers_path)}
      format.js {render 'update_actions' and return}
    end
  end

  private
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    def transfer_params
      params.require(:transfer).permit(:from_store_id, :to_store_id, :sent_date, :note)
    end

    def set_transfers
      transfer_policy = TransferPolicy.new(current_user,TransferPolicy,params)
      @transfer = transfer_policy.resolve
    end

    def check_authorization
      authorize (@transfer || @transfers || Transfer)
    end

end
