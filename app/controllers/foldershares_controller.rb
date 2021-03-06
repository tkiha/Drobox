class FoldersharesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_folder

  def new
  end

  def update
    respond_to do |format|
      @folder.current_user = current_user

      if @folder.update(update_params)
        @folder.deliver_shared_email
        @folder.add_event(Const.event_type.fromshare, current_user.id)
        format.html { redirect_to folder_folder_path(@folder.parent_folder_id, @folder), notice: "#{@folder.name}を共有しました" }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @folder.folder_shares.destroy_all
    @folder.add_event(Const.event_type.fromshare_destroy, current_user.id)
    redirect_to fromshare_items_path, notice: '共有解除しました'
  end

  private
    def set_folder
      @folder = current_user.folders.find(params[:id])
    end

    def update_params
      params.require(:folder).permit(:name, :folder_shares_attributes => [:id, :from_user_id, :to_user_id, :_destroy])
    end

end
