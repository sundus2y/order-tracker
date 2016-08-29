class SearchesController < ApplicationController

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
    search_query = Item.build_search_query(params)
    results = Item.where(search_query).reorder(updated_at: :desc).limit(30)
    respond_to do |format|
      format.html {}
      format.js {render json: results.as_json({type: :search})}
    end
  end

  def orders

  end

  def sales
    @sales = Sale.search(params[:query])
  end

  def transfers
    @transfers = Transfer.search(params[:query])
  end

  def _

  end

end