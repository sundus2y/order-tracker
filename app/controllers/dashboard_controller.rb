class DashboardController < ApplicationController
  impressionist

  def index
    redirect_to new_user_session_path unless user_signed_in?
    if user_signed_in? && @current_user.admin?
      @dash_view = 'admin_dashboard'
      @dash_header = 'admin_dashboard_header'
    elsif user_signed_in? && @current_user.sales?
      @dash_view = 'sales_dashboard'
    end
  end

  def sales_chart_data
    dates =  []
    sales_data = []
    Stats::Sale.monthly_sales.each do |sd|
      dates << sd[0].strftime('%B')
      # dates << sd[0]
      sales_data << sd[1]
    end
    render :json => {dates: dates,sales_data: sales_data}
  end

end