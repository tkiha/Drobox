class SubfoldersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_parent_folder
  before_action :set_folder, only: [:show, :edit, :update, :destroy, :move, :copy]

  def show
  end

  def edit
  end

  def new
    @folder = @parent_folder.sub_folders.build
  end

  def create
    rec_values = folder_params
    rec_values[:user_id] = current_user.id
    @folder = @parent_folder.sub_folders.build(rec_values)

    respond_to do |format|
      if @folder.save
        format.html { redirect_to list_folder_path(@parent_folder), notice: 'フォルダを作成しました' }
      else
        format.html { render :new }
      end
    end
  end

  def move
    respond_to do |format|
      if @folder.update({parent_folder_id: folder_movecopy_params})
        format.html { redirect_to list_folder_path(folder_movecopy_params), notice: '移動しました' }
      else
        format.html { redirect_to list_folder_path(@parent_folder.id) , notice: @folder.errors.messages[:parent_folder_id].join }
      end
    end
  end

  def copy
    respond_to do |format|
      if @folder.deepcopy(folder_movecopy_params)
        format.html { redirect_to list_folder_path(folder_movecopy_params), notice: 'コピーしました' }
      else
        format.html { redirect_to list_folder_path(@parent_folder.id) , notice: @folder.errors.messages[:parent_folder_id].join }
      end
    end
  end

  def update
    respond_to do |format|
      if @folder.update(folder_params)
        format.html { redirect_to folder_folder_path(@parent_folder, @folder), notice: 'フォルダ名を変更しました' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @folder.destroy
    redirect_to list_folder_path(@parent_folder), notice: 'フォルダを削除しました'
  end

  private
    def set_parent_folder
      @parent_folder = current_user.folders.find(params[:folder_id])
    end
    def set_folder
      @folder = @parent_folder.sub_folders.find(params[:id])
    end

    def folder_params
      params.require(:folder).permit(:name)
    end

    def folder_movecopy_params
      params.require(:to_folder_id)
    end
end
