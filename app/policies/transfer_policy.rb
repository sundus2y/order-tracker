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
    new? && @transfer.draft?
  end

  def destroy?
    new? && @transfer.draft?
  end

  def submit?
    new? && @transfer.may_submit?
  end

  def transfer?
    submit? && edit?
  end

  def receive?
    submit? && @transfer.sent?
  end

  def search?
    show?
  end

  def transfer_items?
    show?
  end

  def import_transfer_items?
    @transfer.draft? && @current_user.admin?
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