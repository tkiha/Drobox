class Toshare::UpfilesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_upfile, only: [:show, :download]

  def show
  end

  def download
    send_data(@upfile.file_binary, filename: @upfile.name)
    Event.create(event: "ファイル#{@upfile.name}をダウンロードしました",
                   user_id: current_user.id)
    Event.create(event: "ファイル#{@upfile.name}が#{current_user.email}様にダウンロードされました",
                   user_id: @upfile.user_id)
  end

  private
    def set_upfile
      @upfile = current_user.to_share_files_all.find(params[:id])
    end

end
