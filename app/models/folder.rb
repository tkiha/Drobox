class Folder < ActiveRecord::Base
  belongs_to :own_user, class_name: :User
  has_many :upfiles
  has_many :folder_shares
  has_many :share_users, through: :folder_shares, source: :user

  has_many :sub_folders, class_name: :Folder, foreign_key: :parent_folder_id
  belongs_to :parent_folder, class_name: :Folder, foreign_key: :parent_folder_id


end
