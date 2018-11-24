class TransfersController < ApplicationController
  impressionist

  before_action :set_transfer, except: [:index, :new, :create, :transfer_items]

  before_filter :authenticate_user!
  before_action :check_authorization, except: [:create]
  after_action :verify_authorized

  respond_to :html

  def index
  end

  def show
    respond_with(@transfer)
  end

  def transfer_items
    @transfer_items = Transfer.includes(:transfer_items,transfer_items:[:item]).where(id: params[:id]).first.transfer_items
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
    redirect_to(transfers_path)
  end

  def import_transfer_items
    return redirect_to request.referrer, notice: "Please Select File First" unless params[:file]
    @transfer_items, @error_items = TransferItem.import(params[:file],@transfer)
    flash[:notice] = "All Items Imported Successfully" if @error_items.empty?
    flash[:warning] = "Found #{@error_items.count} Error Items" unless @error_items.empty?
    @grouped_error_items = {
        empty_fields: [],
        item_not_found: []
    }
    @error_items.each do |error_item|
      if error_item['item_number'].to_s.empty? ||
          error_item['original_number'].to_s.empty? ||
          error_item['qty'].to_s.empty? ||
          error_item['brand'].to_s.empty? ||
          error_item['made'].to_s.empty?
        @grouped_error_items[:empty_fields] << error_item
      else
        possible_items = Item.where(item_number: error_item['item_number'])
        @grouped_error_items[:item_not_found] << {possible_items: possible_items, error_item: error_item}
      end
    end
  end

  def submit
    @transfer.submit!
    respond_to do |format|
      format.html {redirect_to(transfers_path)}
    end
  end

  def receive
    @transfer.receiver = current_user
    @transfer.submit!
    respond_to do |format|
      format.html {redirect_to(transfers_path)}
    end
  end

  private
    def set_transfer
      @transfer = Transfer.find(params[:id]||params[:transfer_id])
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
