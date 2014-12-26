class Toshare::SubfoldersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_folder, only: [:show]

  def show
  end

  private
    def set_folder
      @folder = current_user.to_share_folders.find(params[:id])
    end
end
