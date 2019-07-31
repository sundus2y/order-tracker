class CustomersController < ApplicationController
  impressionist actions: CustomersController.action_methods.to_a - ['autocomplete_customer_name','cars']

  autocomplete :customer, :name, :full => true, :display_value => :autocomplete_display,
               :extra_data => [:name, :company, :phone, :tin_no, :category], :limit => 20

  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!
  before_action :set_customer, only: [:show, :edit, :update, :destroy, :pop_up_show, :pop_up_edit]
  before_action :check_authorization, except: [:index, :new, :create]
  after_action :verify_authorized

  respond_to :html

  def index
    @customers = Customer.all.order(:name).page(params[:page]).per_page(10)
    authorize @customers
    respond_with(@customers)
  end

  def vue_index
    if params[:paginate]
      sortOrder = params[:descending] == 'true' ? 'desc' : 'asc'
      sortBy = params[:sortBy].blank? ?  'id' : params[:sortBy]
      limit = params[:rowsPerPage] == '-1' ? Customer.count : params[:rowsPerPage]
      @customers = Customer.paginate(page: params[:page], per_page: limit).order("#{sortBy} #{sortOrder}")
    else
      @customers = Customer.limit(10)
    end

    authorize @customers
    respond_to do |format|
      format.html {}
      format.json {render json: {items: @customers.as_json(), total: @customers.count}}
    end
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

  def cars
    @cars = Car.where(customer_id: params[:customer_id])
  end

  def create
    @customer = Customer.new(customer_params)
    authorize @customer
    flash[:notice] = 'Customer was successfully created.' if @customer.save
    respond_to do |format|
      format.html {respond_with(@customer,location: customers_path)}
      format.json {render json: {item: @customer.as_json(), errors: @customer.errors}}
      format.js
    end
  end

  def update
    flash[:notice] = 'Customer was successfully updated.' if @customer.update(customer_params)
    respond_to do |format|
      format.html {respond_with(@customer,location: customers_path)}
      format.json {render json: {item: @customer.as_json(), errors: @customer.errors}}
      format.js
    end
  end

  def destroy
    @customer.destroy
    respond_to do |format|
      format.html {respond_with(@customer,location: customers_path)}
      format.json {render json: {item: @customer.as_json(), errors: @customer.errors}}
    end
  end

  def pop_up_edit
    render 'pop_up_edit', layout: false
  end

  def pop_up_show
    render 'pop_up_show', layout: false
  end

  private
    def set_customer
      @customer = Customer.find(params[:id] ||params[:customer_id])
    end

    def check_authorization
      authorize @customer || Customer
    end

    def customer_params
      params.require(:customer).permit(:name, :company, :phone, :tin_no, :category, cars_attributes: [:id, :owner, :vin_no,:plate_no,:year,:brand,:model,:_destroy])
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
