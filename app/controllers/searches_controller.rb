class SearchesController < ApplicationController

  def all
  end

  def items
    results = Item.search_item2(params[:search_term])
    render json: results.as_json({type: :search})
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