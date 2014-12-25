class FromshareItemsController < ApplicationController
  include Items_orderby
  before_filter :authenticate_user!
  before_action :set_orderby, only: [:show]

  def show
  end

end
