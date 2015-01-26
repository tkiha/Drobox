class FilesharesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_upfile

  def new
  end

  def update
    respond_to do |format|
      if @upfile.update(update_params)
        sendmail
        Event.create(event: "ファイル#{@upfile.name}を共有しました",
                user_id: current_user.id)
        format.html { redirect_to folder_upfile_path(@upfile.folder, @upfile), notice: "#{@upfile.name}を共有しました" }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @upfile.file_shares.destroy_all
    Event.create(event: "ファイル#{@upfile.name}の共有を解除しました",
            user_id: current_user.id)
    redirect_to fromshare_items_path, notice: '共有解除しました'
  end

  private
    def set_upfile
      @upfile = current_user.upfiles.find(params[:id])
    end

    def update_params
      params[:upfile].try("[]",:file_shares_attributes).try(:each) do |item|
        item.last[:from_user_id] = current_user.id
      end
      params.require(:upfile).permit(:name, :file_shares_attributes => [:id, :from_user_id, :to_user_id, :_destroy])
    end

    def sendmail
      @upfile.file_shares.each do |item|
        NoticeMailer.sendmail_share(@upfile, current_user, item.to_user).deliver
        p "メール本文-->#{ActionMailer::Base.deliveries.last.body}"
      end
    end
end
