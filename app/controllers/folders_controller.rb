class FoldersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_orderby, only: [:index]
  before_action :set_user
  before_action :set_folder


  def search
   # render json: { result: @folder.get_family_folders }
   @search_result =  @folder.get_family_folders 
  end


  private
    def set_user
      @user = User.find(current_user)
    end
    def set_folder
      @folder = @user.folders.get_folder_or_root(params[:id])
    end

    def set_orderby
      session[self.class.name] = {
        Const.orderby.field.file => Const.orderby.none,
        Const.orderby.field.type => Const.orderby.none,
        Const.orderby.field.time => Const.orderby.none,
      }
      session[self.class.name][params[:f]] = params[:o] if params[:f].present? && params[:o].present?
      @orderby = session[self.class.name]
      # p @orderby
    end

end
