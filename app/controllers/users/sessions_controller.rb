class Users::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate(auth_options)

    if resource
      if resource.user_role == params[:user][:user_role]
        set_flash_message!(:notice, :signed_in)
        sign_in(resource_name, resource)
        yield resource if block_given?
        respond_with resource, location: after_sign_in_path_for(resource)
      else
        sign_out resource # security: log them out if role mismatches
        flash.now[:alert] = "Access denied: You are not a #{params[:user][:user_role].capitalize}."
        @resource = resource_class.new(sign_in_params) # repopulate form
        render :new, status: :unauthorized
      end
    else
      flash.now[:alert] = "Invalid email or password"
      @resource = resource_class.new(sign_in_params)
      render :new, status: :unauthorized
    end
  end
end
