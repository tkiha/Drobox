class FoldersharesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user, :set_folder

  def new
    3.times {@folder.folder_shares.build}
  end

  private
    def set_user
      @user = User.find(current_user)
    end
    def set_folder
      @folder = @user.folders.find(params[:folder_id])
    end

end
