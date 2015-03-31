class AuthenticationController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
    end
  end

  def new
  end

  def destroy
    session.clear
  end
end
