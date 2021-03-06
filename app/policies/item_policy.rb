class ItemPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @item = model
  end

  def index?
    true
    # @current_user.admin?
  end

  def show?
    true
    # @current_user.admin? or @current_user == @user
  end

  def new?
    @current_user.admin?
  end

  def update?
    @current_user.admin?
  end

  def edit?
    @current_user.admin?
  end

  def destroy?
    @current_user.admin?
  end

end
