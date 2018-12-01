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
    if @current_user.user? || @current_user.vendor?
      return false
    elsif @sale != Sale
      @current_user.can_access_sale_record?(@sale)
    else
      true
    end
  end

  def new?
    @current_user.admin? || @current_user.sales?
  end

  def create?
    new?
  end

  def update?
    new? & show?
  end

  def edit?
    new? && show? && (@sale.draft? || @sale.ordered?)
  end

  def pop_up_fs_num_edit?
    new? && show? && @sale.sold?
  end

  def destroy?
    edit? && @sale.may_delete_draft?
  end

  def search?
    !@current_user.user? && !@current_user.vendor?
  end

  def sale_items?
    show?
  end

  def submit_to_sold?
    new? && show? && @sale.may_submit?
  end

  def submit_to_ordered?
    new? && show? && @sale.may_submit_to_ordered?
  end

  def mark_as_sold?
    new? && show? && @sale.may_mark_as_sold?
  end

  def submit_to_credited?
    new? && show? && @sale.may_credit?
  end

  def submit_to_sampled?
    new? && show? && @sale.may_sample?
  end

  def return?
    new? & show?
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