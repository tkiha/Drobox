class FoldersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user, only: [:index, :create, :new, :show, :edit, :update, :destroy]
  before_action :set_parent_folder, only: [:new, :create, :show, :edit, :update, :destroy]
  before_action :set_folder, only: [:show, :edit, :update, :destroy]

  def index
    @folder = @user.folders.get_folder_or_root(params[:id])
  end

  def show
  end

  def new
    @folder = @parent_folder.sub_folders.build
  end

  def edit
  end

  def create
    rec_values = folder_params
    rec_values[:user_id] = @user.id
    @folder = @parent_folder.sub_folders.build(rec_values)

    respond_to do |format|
      if @folder.save
        format.html { redirect_to list_folder_path(@parent_folder), notice: 'フォルダを作成しました' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @folder.update(folder_params)
        format.html { redirect_to @folder, notice: 'Folder was successfully updated.' }
        format.json { render :show, status: :ok, location: @folder }
      else
        format.html { render :edit }
        format.json { render json: @folder.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @folder.destroy
        format.html { redirect_to folders_url, notice: 'フォルダを削除しました' }
      else
        p @folder.errors.messages[:custom_check]
        format.html { redirect_to folders_url, notice: @folder.errors.messages[:custom_check].join }

      end
    end
  end

  private
    def set_user
      @user = User.find(current_user)
    end
    def set_parent_folder
      @parent_folder = @user.folders.find(params[:folder_id])
    end
    def set_folder
      @folder = @parent_folder.sub_folders.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def folder_params
      params.require(:folder).permit(:name)
    end
end
