class Toshare::ItemsController < ApplicationController
  include ItemsOrderby
  before_filter :authenticate_user!
  before_action :set_orderby, only: [:index]

  def index
  end

end
