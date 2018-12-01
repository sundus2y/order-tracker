class UsersController < ApplicationController
  impressionist

  before_filter :authenticate_user!
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
    respond_with(@user)
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
