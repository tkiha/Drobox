class ToshareFoldersController < ApplicationController
  include List_orderby
  before_filter :authenticate_user!
  before_action :set_orderby, only: [:index]
  before_action :set_folder

  def index
  end

  private
    def set_folder
      @folder = current_user.to_share_folders.find(params[:id])
    end

end
