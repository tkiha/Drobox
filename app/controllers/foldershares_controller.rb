class FoldersharesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_folder

  def new
    @folder.folder_shares.build if @folder.folder_shares.blank?
  end

  def update
    respond_to do |format|
      if @folder.update(update_params)
        format.html { redirect_to folder_folder_path(@folder.parent_folder, @folder), notice: "#{@folder.name}を共有しました" }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @folder.folder_shares.destroy_all
    redirect_to list_from_share_path, notice: '共有解除しました'
  end

private
    def set_folder
      @folder = current_user.folders.find(params[:folder_id])
    end

    def update_params
      params[:folder][:folder_shares_attributes].each do |item|
        item.last[:from_user_id] = current_user.id
      end
      params.require(:folder).permit(:name, :folder_shares_attributes => [:id, :from_user_id, :to_user_id, :_destroy])
    end
end
