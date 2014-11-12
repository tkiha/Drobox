class User::SessionsController < Devise::SessionsController
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
    render json: { result: true }
  end

  def xhr_failure
    p I18n.t('devise.failure.invalid')
    render json: { error: I18n.t('devise.failure.invalid') },status: Const.xhr.status.error and return
  end
end
