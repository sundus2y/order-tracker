class SaleItemPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @sale_item = model
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

  # def resolve
  #   if @current_user.sales?
  #     SaleItem.draft
  #   elsif @current_user.admin?
  #     SaleItem.all
  #   else
  #     []
  #   end
  # end

end