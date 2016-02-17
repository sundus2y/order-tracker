class OrderPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @item = model
  end

  def index?
    @current_user.admin? || @current_user.vendor?
  end

  def show?
    @current_user.admin? || @current_user.vendor?
  end

  def show_all?
    show?
  end

  def show_selected?
    show?
  end

  def submit_to_ordered?
    new?
  end

  def new?
    @current_user.admin?
  end

  def create?
    new?
  end

  def update?
    @current_user.admin? && @item.draft?
  end

  def edit?
    @current_user.admin? && @item.draft?
  end

  def destroy?
    @current_user.admin? && @item.draft?
  end

  def resolve
    if @current_user.vendor?
      Order.ordered
    elsif @current_user.admin?
      Order.all
    else
      Order.no_order
    end
  end

end
