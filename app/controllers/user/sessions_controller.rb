class User::SessionsController < Devise::SessionsController
  def new
    if request.xhr?
      p " new!! sign_in_params:#{sign_in_params}"
      p "!!#{login_error_message}"
      self.resource = resource_class.new(sign_in_params)
      p "!!#{login_error_message}"
      p " self.resource:#{self.resource}"
      clean_up_passwords(resource)
      p " resource:#{resource}"
      p " serialize_options(resource):#{serialize_options(resource)}"
      # respond_with(resource, serialize_options(resource))
      xhr_failure
    else
      super
    end
  end


  def create
    if request.xhr?
      p "xhr!#{resource_name} #{resource_class} "
      opts = auth_options
      opts[:recall] = "#{controller_path}#xhr_failure"
      p "opts : #{opts}"
      self.resource = warden.authenticate!(opts)
      p "self.resource : #{self.resource}"
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
