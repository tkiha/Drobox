class UpfilesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_folder
  before_action :set_upfiles, only: [:new, :create]
  before_action :set_upfile, only: [:show, :edit, :update, :destroy, :download, :move, :copy]

  def show
  end

  def edit
  end

  def new
    @upfile = @upfiles.build
  end

  def move
    respond_to do |format|
      if @upfile.move(upfile_movecopy_params)
        format.html { redirect_to folder_path(upfile_movecopy_params), notice: '移動しました' }
      else
        format.html { redirect_to folder_path(@folder.id), notice: @upfile.errors.messages[:folder_id].join }
      end
    end
  end

  def copy
    respond_to do |format|
      if @upfile.copy(upfile_movecopy_params)
        format.html { redirect_to folder_path(upfile_movecopy_params), notice: 'コピーしました' }
      else
        format.html { redirect_to folder_path(@folder.id), notice: @upfile.errors.messages[:folder_id].join }
      end
    end
  end

  def download
    send_data(@upfile.file_binary, filename: @upfile.name)
    @upfile.add_event(Const.event_type.download, current_user.id)
  end

  def create
    upload_file = upfile_params.blank? ? nil : upfile_params[:upload_file]
    rec_values  = {}
    if upload_file.present?
      rec_values[:file_binary] = upload_file.read
      rec_values[:name]        = upload_file.original_filename
    end
    rec_values[:user_id] = current_user.id

    @upfile = @upfiles.build(rec_values)
    respond_to do |format|
      if @upfile.save
        format.html { redirect_to folder_path(@folder), notice: 'ファイルをアップロードしました' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @upfile.update(upfile_edit_params)
        format.html { redirect_to folder_upfile_path(@folder, @upfile), notice: '更新しました' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @upfile.destroy
    respond_to do |format|
      format.html { redirect_to folder_path(@folder), notice: 'ファイルを削除しました' }
    end
  end

  private
  def set_folder
    @folder = current_user.folders.find(params[:folder_id])
  end

  def set_upfiles
    @upfiles = @folder.upfiles
  end

  def set_upfile
    @upfile = @folder.upfiles.find(params[:id])
  end

  def upfile_params
    params.fetch(:upfile, {}).permit(:upload_file)
  end

  def upfile_edit_params
    params.require(:upfile).permit(:name)
  end

  def upfile_movecopy_params
    params.require(:to_folder_id)
  end
end
