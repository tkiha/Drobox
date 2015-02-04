class FilesharesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_upfile

  def new
  end

  def update
    respond_to do |format|
      @upfile.current_user = current_user

      if @upfile.update(update_params)
        @upfile.deliver_shared_email
        @upfile.add_event(Const.event_type.fromshare, current_user.id)
        format.html { redirect_to folder_upfile_path(@upfile.folder, @upfile), notice: "#{@upfile.name}を共有しました" }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @upfile.file_shares.destroy_all
    @upfile.add_event(Const.event_type.fromshare_destroy, current_user.id)
    redirect_to fromshare_items_path, notice: '共有解除しました'
  end

  private
    def set_upfile
      @upfile = current_user.upfiles.find(params[:id])
    end

    def update_params
      params.require(:upfile).permit(:name, :file_shares_attributes => [:id, :from_user_id, :to_user_id, :_destroy])
    end
end
