class UsersController < ApplicationController
  def index
    @users = User.all
    #render a json. this should be private somehow.
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
