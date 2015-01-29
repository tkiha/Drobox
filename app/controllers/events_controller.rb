class EventsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @events = current_user.events.order('updated_at DESC,id DESC').page(params[:page]).per(5)
  end
end
