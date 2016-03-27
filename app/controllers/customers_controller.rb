class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :check_authorization, except: [:index, :new, :create]
  after_action :verify_authorized

  respond_to :html

  def index
    @customers = Customer.all.order(:name).page(params[:page]).per_page(10)
    authorize @customers
    respond_with(@customers)
  end

  def show
    respond_with(@customer)
  end

  def new
    @customer = Customer.new
    authorize @customer
    respond_with(@customer)
  end

  def edit
  end

  def create
    @customer = Customer.new(customer_params)
    authorize @customer
    flash[:notice] = 'Customer was successfully created.' if @customer.save
    respond_to do |format|
      format.html {respond_with(@customer,location: customers_path)}
      format.js
    end
  end

  def update
    flash[:notice] = 'Customer was successfully updated.' if @customer.update(customer_params)
    respond_with(@customer,location: customer_path)
  end

  def destroy
    @customer.destroy
    respond_with(@customer)
  end

  private
    def set_customer
      @customer = Customer.find(params[:id])
    end

    def check_authorization
      authorize @customer || Customer
    end

    def customer_params
      params.require(:customer).permit(:name, :company, :phone)
    end
end
