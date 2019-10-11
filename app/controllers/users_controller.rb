class UsersController < ApplicationController
  impressionist

  before_action :authenticate_user!
  before_action :set_user, only: [:show, :update, :destroy, :activity_log]
  before_action :set_users, only: [:index]
  before_action :check_authorization
  after_action :verify_authorized, except: [:make_admin]

  def index
  end

  def show
  end

  def update
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def make_admin
    user = User.where(email:'admin@ots.com').first
    user.role = :admin
    user.save!
    redirect_to root_path, :notice => "Sundus is now Admin"
  end

  def activity_log
    query = <<-SQL
SELECT DATE(created_at), 
       COUNT(*) number_of_requests, 
       MAX(created_at) as last_access_at, 
       MIN(created_at) as first_access_at,
       STRING_AGG(DISTINCT ip_address, ' , ') as ips
FROM impressions
WHERE user_id = #{@user.id} AND created_at > '#{Time.zone.today - 6.months}'
GROUP BY DATE(created_at)
    SQL
    @impressions = ActiveRecord::Base.connection.select_all(query)
  end

  private

  def secure_params
    params.require(:user).permit(:role,:default_store_id)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_users
    @users = User.all
  end

  def check_authorization
    authorize (@user || @users || User)
  end

end
