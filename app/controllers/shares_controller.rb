class SharesController < ApplicationController
  include List_orderby
  before_filter :authenticate_user!
  before_action :set_orderby, only: [:fromshares, :toshares]

  def fromshares
  end

  def toshares
  end
end
