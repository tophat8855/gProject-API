class SessionsController < Devise::SessionsController
  skip_before_filter :configure_permitted_parameters!
  respond_to :html, :json

  def create
  #  respond_to do |format|
  #    format.html { super }
  #    format.json do
  #      self.resource = warden.authenticate!(auth_options)
  #      sign_in(resource_name, resource)
    super do |user|
      if request.format.json?
        data = {
          token: user.authentication_token,
          email: user.email,
          user_id: user.id
        }
        render json: data, status: 201 and return
      end
    end
  end
end
