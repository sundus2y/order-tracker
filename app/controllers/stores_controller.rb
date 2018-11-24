class StoresController < ApplicationController
  impressionist

  def index
    @stores = Store.all
  end

  def sales
    @sales = Store.find(params[:store_id]).sales.includes(:customer).reorder(updated_at: :desc)
  end

  def for_sales
    @stores = Store.for_sales
    render 'index' and return
  end

end