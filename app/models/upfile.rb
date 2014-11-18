class Upfile < ActiveRecord::Base
  belongs_to :folder
  belongs_to :own_user, class_name: :User
  has_many :file_shares
  # has_many :to_share_users, class_name: :User, foreign_key: :upfile_id, through: :file_shares
  has_many :share_users, through: :file_shares, source: :user
end
