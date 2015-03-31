class UsersController < ApplicationController
  def index
    @users = User.all

    render json: @users  # this should be private somehow.
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
