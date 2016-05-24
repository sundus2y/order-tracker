class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :edit, :update, :destroy]
  before_action :set_transfers, only:[:index, :show_all]

  before_filter :authenticate_user!
  before_action :check_authorization
  after_action :verify_authorized

  respond_to :html

  def index
    @transfers = Transfer.all
    respond_with(@transfers)
  end

  def show
    respond_with(@transfer)
  end

  def new
    @transfer = Transfer.new
    respond_with(@transfer)
  end

  def edit
  end

  def create
    @transfer = Transfer.new(transfer_params)
    flash[:notice] = 'Transfer was successfully created.' if @transfer.save
    respond_with(@transfer)
  end

  def update
    flash[:notice] = 'Transfer was successfully updated.' if @transfer.update(transfer_params)
    respond_with(@transfer)
  end

  def destroy
    @transfer.destroy
    respond_with(@transfer)
  end

  private
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    def transfer_params
      params.require(:transfer).permit(:from_store, :to_store, :note)
    end

    def set_transfers
      transfer_policy = TransferPolicy.new(current_user,TransferPolicy,params)
      @transfer = transfer_policy.resolve
    end

    def check_authorization
      authorize (@transfer || @transferss || Transfer)
    end

end
