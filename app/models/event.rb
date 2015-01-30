class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :upfile
  belongs_to :folder

end
