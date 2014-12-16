class FoldersharesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_folder

  def new
    @folder.folder_shares.build
  end

  def edit
    @folder.folder_shares.build
    p "--> #{params.inspect}"
  end

  private
    def set_folder
      @folder = current_user.folders.find(params[:folder_id])
    end

    def edit_params
          params.require(:folder).permit(:name, :folder_shares_attributes => [:id, :to_user_id, :_destroy])
    end
end
