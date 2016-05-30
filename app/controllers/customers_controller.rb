class CustomersController < ApplicationController
  autocomplete :customer, :name, :full => true, :display_value => :autocomplete_display,
               :extra_data => [:name, :company, :phone, :tin_no, :category], :limit => 20

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
    respond_with(@customer,location: customers_path)
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
      params.require(:customer).permit(:name, :company, :phone, :tin_no, :category)
    end

    def get_autocomplete_items(parameters)
      model = Customer
      limit = parameters[:options][:limit]
      data = parameters[:options][:extra_data]
      data << parameters[:method]
      model.where("LOWER(name) like LOWER(:term) or
                    LOWER(company) like LOWER(:term) or
                    LOWER(phone) like LOWER(:term) or
                    LOWER(tin_no) like LOWER(:term)",
                  term: "%#{parameters[:term]}%").limit(limit)
    end

end
