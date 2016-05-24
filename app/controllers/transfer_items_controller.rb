class TransferItemsController < ApplicationController
  before_action :set_transfer_item, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!
  before_action :check_authorization
  after_action :verify_authorized

  respond_to :html

  def index
    @transfer_items = TransferItem.all
    respond_with(@transfer_items)
  end

  def show
    respond_with(@transfer_item)
  end

  def new
    @transfer_item = TransferItem.new
    respond_with(@transfer_item)
  end

  def edit
  end

  def create
    @transfer_item = TransferItem.new(transfer_item_params)
    @transfer_item.save
    respond_with(@transfer_item)
  end

  def update
    @transfer_item.update(transfer_item_params)
    respond_with(@transfer_item)
  end

  def destroy
    @transfer_item.destroy
    respond_with(@transfer_item)
  end

  private
    def set_transfer_item
      @transfer_item = TransferItem.find(params[:id])
    end

    def transfer_item_params
      params.require(:transfer_item).permit(:transfer_id, :item_id, :qty, :status)
    end

    def check_authorization
      authorize (@transfer_item || TransferItem)
    end
end
