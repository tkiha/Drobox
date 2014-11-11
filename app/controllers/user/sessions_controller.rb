class User::SessionsController < Devise::SessionsController
  def create
    p 'aaaa'
    xhr_success
    # if request.xhr?
    #   opts = auth_options
    #   opts[:recall] = "#{controller_path}#xhr_failure"
    #   self.resource = warden.authenticate!(opts)
    #   sign_in(resource_name, resource)
    #   xhr_success
    # else
    #   super
    # end
  end

  def xhr_success
    render json: { result: true }
  end

  def xhr_failure
    render json: { result: false, errors: ["Login failed."] }
  end
end
