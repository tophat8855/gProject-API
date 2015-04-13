class ApplicationController < ActionController::Base
  require 'csv'
  before_filter :authenticate_user_from_token!
  #before_filter :authenticate_user!

  before_filter :configure_permitted_parameters!, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  def current_user
    @current_user
    #User.find_by(id: session[:user_id])
  end

  helper_method :current_user


  private
    def authenticate_user_from_token!
      authenticate_with_http_token do |token, options|
      user_email = options[:email].presence
      user = user_email && User.find_by_email(user_email)

      if user && Devise.secure_compare(user.authentication_token, token)
        sign_in user#, store: false
        @current_user = user
      else
        @current_user = nil
      end
    end
  end

  protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
  # end
end
