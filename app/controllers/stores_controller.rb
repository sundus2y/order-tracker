class StoresController < ApplicationController

  def index
    @stores = Store.all
  end

  def sales
    @sales = Store.find(params[:store_id]).sales.reorder(updated_at: :asc)
  end

end