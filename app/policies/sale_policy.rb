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
    new? && @sale.draft?
  end

  def pop_up_fs_num_edit?
    new? && @sale.sold?
  end

  def destroy?
    edit? && @sale.may_delete_draft?
  end

  def search?
    show?
  end

  def sale_items?
    show?
  end

  def submit_to_sold?
    new? && @sale.may_submit?
  end

  def mark_as_sold?
    new? && @sale.may_mark_as_sold?
  end

  def submit_to_credited?
    new? && @sale.may_credit?
  end

  def submit_to_sampled?
    new? && @sale.may_sample?
  end

  def return?
    new?
  end

  def stores?
    new?
  end

  def print?
    show? && !@sale.draft?
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