class User::SessionsController < Devise::SessionsController
  def new
    if request.xhr?
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      # respond_with(resource, serialize_options(resource))
      xhr_failure
    else
       p "new-2"
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      redirect_to root_path
    end
  end


  def create
    p "create"
    if request.xhr?
      p "create-1"
      opts = auth_options
      opts[:recall] = "#{controller_path}#xhr_failure"
      p "create-1-1 #{opts.inspect}"
      self.resource = warden.authenticate!(opts)
      p "create-1-2 #{self.resource.inspect}"
      sign_in(resource_name, resource)
      p "create-1-3#{self.resource.inspect}"
      xhr_success
    else
       p "create-2"
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
