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
    !@current_user.user?
    # @current_user.admin? or @current_user == @user
  end

  def new?
    @current_user.admin?
  end

  def create?
    new?
  end

  def import?
    @current_user.admin?
  end

  def import_export?
    @current_user.admin?
  end

  def template?
    @current_user.admin?
  end

  def download?
    @current_user.admin?
  end

  def autocomplete_item_name?
    true
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

  def search?
    !@current_user.user?
  end

end
