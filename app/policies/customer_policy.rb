class CustomerPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @customer = model
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
    @current_user.admin? || @current_user.sales?
  end

  def edit?
    @current_user.admin? || @current_user.sales?
  end

  def destroy?
    @current_user.admin? || @current_user.sales?
  end

  def search?
    !@current_user.user? && !@current_user.vendor?
  end

  def autocomplete_customer_name?
    !@current_user.user? && !@current_user.vendor?
  end

end