class ApplicationController < ActionController::Base
  require 'csv'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def current_user
    User.find_by(id: session[:user_id])
  end

  helpermethod :current_user
end
