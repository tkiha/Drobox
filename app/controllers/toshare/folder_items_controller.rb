class Toshare::FolderItemsController < ApplicationController
  include Items_orderby
  before_filter :authenticate_user!
  before_action :set_orderby, only: [:show]
  before_action :set_folder

  def show
  end

  private
    def set_folder
      @folder = current_user.to_share_folders.find(params[:id])
    end

end
