class FoldersharesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_folder

  def new
    @folder.folder_shares.build if @folder.folder_shares.blank?
  end

  def update
    respond_to do |format|
      if @folder.update(update_params)
        sendmail
        Event.create(event: "フォルダ#{@folder.name}を共有しました",
                 user_id: current_user.id)
        format.html { redirect_to folder_folder_path(@folder.parent_folder_id, @folder), notice: "#{@folder.name}を共有しました" }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @folder.folder_shares.destroy_all
    Event.create(event: "フォルダ#{@folder.name}の共有を解除しました",
             user_id: current_user.id)
    redirect_to fromshare_items_path, notice: '共有解除しました'
  end

  private
    def set_folder
      @folder = current_user.folders.find(params[:id])
    end

    def update_params
      params[:folder].try("[]",:folder_shares_attributes).try(:each) do |item|
        item.last[:from_user_id] = current_user.id
      end
      params.require(:folder).permit(:name, :folder_shares_attributes => [:id, :from_user_id, :to_user_id, :_destroy])
    end

    def sendmail
      @folder.folder_shares.each do |item|
        NoticeMailer.sendmail_share(@folder, current_user, item.to_user).deliver
        p "メール本文-->#{ActionMailer::Base.deliveries.last.body}"
      end
    end
end
