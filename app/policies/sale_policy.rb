class SalePolicy
  attr_reader :current_user, :model

  def initialize(current_user, model,params=nil)
    @current_user = current_user
    @sale = model
    @params = params
  end

  def index?
    true
  end

  def show?
    !@current_user.user? && !@current_user.vendor?
  end

  def new?
    @current_user.admin? || @current_user.sales?
  end

  def create?
    new?
  end

  def update?
    new?
  end

  def edit?
    new?
  end

  def destroy?
    new?
  end

  def search?
    show?
  end

  def sale_items?
    show?
  end

  def submit_to_sold?
    new?
  end

  def submit_to_credited?
    new?
  end

  def submit_to_sampled?
    new?
  end

  def return?
    new?
  end

  def stores?
    new?
  end

  def resolve
    if @current_user.sales?
      Sale.draft.page(@params[:page]).per_page(10)
    elsif @current_user.admin?
      Sale.all.page(@params[:page]).per_page(10)
    else
      []
    end
  end

end