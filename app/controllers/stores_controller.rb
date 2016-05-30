class StoresController < ApplicationController

  def index
    @stores = Store.all
  end

  def sales
    @sales = Store.find(params[:store_id]).sales.includes(:customer).reorder(updated_at: :asc)
  end

end