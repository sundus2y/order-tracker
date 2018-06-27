class ProformaPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model,params=nil)
    @current_user = current_user
    @proforma = model
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
    edit? && @proforma.may_delete_draft?
  end

  def search?
    show?
  end

  def proforma_items?
    show?
  end

  def submit_to_submitted?
    new? && @proforma.may_submit?
  end

  def mark_as_sold?
    new? && @proforma.may_mark_as_sold?
  end

  def print?
    show? && !@proforma.draft?
  end

  def resolve
    if @current_user.sales?
      Proforma.draft.page(@params[:page]).per_page(10)
    elsif @current_user.admin?
      Proforma.all.page(@params[:page]).per_page(10)
    else
      []
    end
  end

end