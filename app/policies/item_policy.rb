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

  def pop_up_show?
    show?
  end

  def pop_up_edit?
    edit?
  end

  def import?
    @current_user.admin?
  end

  def import_non_original?
    import?
  end

  def bulk_update?
    import?
  end

  def import_export?
    @current_user.admin?
  end

  def template?
    @current_user.admin?
  end

  def non_original_template?
    template?
  end

  def bulk_update_template?
    template?
  end

  def download?
    @current_user.admin?
  end

  def download_inventory?
    @current_user.admin?
  end

  def autocomplete_item_name?
    true
  end

  def autocomplete_item_sale_price?
    @current_user.admin? || @current_user.sales?
  end

  def autocomplete_item_sale_order?
    autocomplete_item_sale_price?
  end

  def update?
    @current_user.admin?
  end

  def edit?
    @current_user.admin?
  end

  def destroy?
    @current_user.admin? && (@item.class == Class || @item.can_be_deleted?)
  end

  def search?
    !@current_user.user?
  end

end
