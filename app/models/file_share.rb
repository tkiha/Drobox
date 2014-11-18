class FileShare < ActiveRecord::Base
  belongs_to :user
  belongs_to :upfile
end
