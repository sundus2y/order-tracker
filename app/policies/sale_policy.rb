class SalePolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @sale = model
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

  def resolve
    if @current_user.sales?
      Sale.draft
    elsif @current_user.admin?
      Sale.all
    else
      []
    end
  end

end