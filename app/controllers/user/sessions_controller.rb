class User::SessionsController < Devise::SessionsController
  def new
    if request.xhr?
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      # respond_with(resource, serialize_options(resource))
      xhr_failure
    else
      super
    end
  end


  def create
    if request.xhr?
      opts = auth_options
      opts[:recall] = "#{controller_path}#xhr_failure"
      self.resource = warden.authenticate!(opts)
      sign_in(resource_name, resource)
      xhr_success
    else
      super
    end
  end

  def xhr_success
    p 'login OK!!'
    render json: { result: true }
  end

  def xhr_failure
    "login NG!!#{login_error_message}"
    render json: { error:login_error_message },status: Const.xhr.status.error and return
  end

  def login_error_message
    flash[:alert]
  end

end
