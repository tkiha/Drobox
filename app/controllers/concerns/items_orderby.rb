module Items_orderby
  extend ActiveSupport::Concern

  included do
    def set_orderby
      session[self.class.name] = {
        Const.orderby.field.file => Const.orderby.none,
        Const.orderby.field.type => Const.orderby.none,
        Const.orderby.field.time => Const.orderby.none,
        Const.orderby.field.owner => Const.orderby.none,
      }
      session[self.class.name][params[:f]] = params[:o] if params[:f].present? && params[:o].present?
      @orderby = session[self.class.name]
      # p @orderby
    end

  end
end
