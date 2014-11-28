class UpfilesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user, :set_folder, :set_upfile, only: [:new, :create, :show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @upfile = @upfile.build
  end

  def edit
  end

  def create
    upload_file = upfile_params.blank? ? nil : upfile_params[:upload_file]
    rec_values = {}
    if upload_file.present?
      rec_values[:file_binary] = upload_file.read
      rec_values[:name] = upload_file.original_filename
    end
    rec_values[:user_id] = @user.id


    @upfile = @upfile.build(rec_values)

    respond_to do |format|
      if @upfile.save
        format.html { redirect_to list_folder_path(@folder), notice: 'ファイルをアップロードしました' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @upfile.update(upfile_params)
        format.html { redirect_to @upfile, notice: 'Upfile was successfully updated.' }
        format.json { render :show, status: :ok, location: @upfile }
      else
        format.html { render :edit }
        format.json { render json: @upfile.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @upfile.destroy
    respond_to do |format|
      format.html { redirect_to upfiles_url, notice: 'Upfile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
      @user = User.find(current_user)
    end
    def set_folder
      @folder = @user.folders.find(params[:folder_id])
    end
    def set_upfile
      @upfile = @folder.upfiles
      p "---> #{@folder.inspect}"
    end

    def upfile_params
      params.fetch(:upfile,{}).permit(:upload_file)
    end
end
