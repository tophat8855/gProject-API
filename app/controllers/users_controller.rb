class UsersController < ApplicationController
  before_filter :authenticate_user!, only: [:delete]
  skip_before_filter :verify_authenticity_token

  def index
    @users = User.all
    render json: @users  # this should be private somehow.
  end

  def create
    @user = User.new(user_params)
    if  @user.save
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    render json: @user #also make this private
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
