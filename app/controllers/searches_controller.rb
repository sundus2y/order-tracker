class SearchesController < ApplicationController

  before_filter :authenticate_user!
  after_action :verify_authorized, except: [:item_lookup]

  def all
  end

  def item_lookup
    @lookup = {}
    @lookup[:cars] = Item.fetch_cars
    @lookup[:part_classes] = Item.fetch_part_classes
    @lookup[:brands] = Item.fetch_brands
    @lookup[:mades] = Item.fetch_mades
    @lookup = OpenStruct.new(@lookup)
  end

  def items
    # TODO: Fix the id column for search on items with inventory only
    search_type = :admin_search
    begin
      authorize Item, :destroy?
    rescue Pundit::NotAuthorizedError => e
      authorize Item, :search?
      search_type = :regular_search
    end
    search_query = Item.build_search_query(params)
    results = Item.includes({inventories: :store}, :order_items).where(search_query).reorder(updated_at: :desc).limit(30).as_json({type: search_type}) unless params[:inventory].present?
    results = Item.joins(:inventories, {inventories: :store}).includes({inventories: :store}, :order_items).where(search_query).where("stores.active = true and stores.store_type != 'VS'").reorder(updated_at: :desc).limit(30).as_json({type: search_type}) if params[:inventory].present?
    results.map{|item| item.transform_keys!{|key| Item::KEY_MAP[key] || key }}
    respond_to do |format|
      format.html {}
      format.js {render json: results}
    end
  end

  def orders
    authorize Order, :search?
  end

  def sales
    authorize Sale, :search?
    @sales = Sale.search(params[:query])
  end

  def transfers
    authorize Transfer, :search?
    @transfers = Transfer.search(params[:query]).limit(15)
  end

  def vin
    authorize Sale, :search?
  end

  def customers
    search_type = :admin_search
    begin
      authorize Customer, :destroy?
    rescue Pundit::NotAuthorizedError => e
      authorize Customer, :search?
      search_type = :regular_search
    end
    @customers = Customer.search(params).reorder(:name).limit(20).as_json({type: search_type})
    @customers.map{|item| item.transform_keys!{|key| Item::KEY_MAP[key] || key }}
    respond_to do |format|
      format.html {}
      format.js {render json: @customers}
    end
  end

  def _

  end

end