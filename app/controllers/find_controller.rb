class FindController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_folder

  def new
  end

  def show
    @input_name = find_params
    @upfiles = current_user.upfiles.where('name like ?',  "%#{@input_name}%").order(:name)
    flash.now[:notice] = "検索結果：#{@upfiles.count}件"
    render action: :new
  end

  private
    def set_folder
      @folder = current_user.folders.get_folder_or_root(params[:folder_id])
    end
    def find_params
      params.fetch(:name,'')
    end


end
