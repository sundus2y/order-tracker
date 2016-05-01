class SearchesController < ApplicationController

  def all
  end

  def items
    results = Item.search_item2(params[:search_term])
    render json: results.to_json
  end

  def orders

  end

  def sales
    result = Sale.search(params[:query])
    render json: result.as_json({type: :search})
  end

  def _

  end

end