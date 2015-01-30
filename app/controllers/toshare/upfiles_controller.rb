class Toshare::UpfilesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_upfile, only: [:show, :download]

  def show
  end

  def download
    send_data(@upfile.file_binary, filename: @upfile.name)
    @upfile.add_event(Const.event_type.download, current_user.id)
  end

  private
    def set_upfile
      @upfile = current_user.to_share_files_all.find(params[:id])
    end

end
