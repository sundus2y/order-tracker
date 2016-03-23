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

  end

  def _

  end

end