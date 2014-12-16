class FoldersController < ApplicationController
  include List_orderby
  before_filter :authenticate_user!
  before_action :set_orderby, only: [:index]
  before_action :set_folder

  def index
  end

  def search
   @search_result =  @folder.get_family_folders
  end

  private
    def set_folder
      @folder = current_user.folders.get_folder_or_root(params[:id])
    end

end
