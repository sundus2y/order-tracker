class TransferPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model,params=nil)
    @current_user = current_user
    @transfer = model
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

  def resolve
    if @current_user.sales?
      Transfer.draft.page(@params[:page]).per_page(10)
    elsif @current_user.admin?
      Transfer.all.page(@params[:page]).per_page(10)
    else
      []
    end
  end

end