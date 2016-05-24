class TransfersController < ApplicationController
  before_action :set_transfer, only: [:show, :edit, :update, :destroy]

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
end
