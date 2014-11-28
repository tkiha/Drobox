class Upfile < ActiveRecord::Base
  belongs_to :folder
  belongs_to :own_user, class_name: :User
  has_many :file_shares
  has_many :from_share_users, through: :file_shares, source: :from_user

  validates :name, presence: true,
    length: {maximum: 100}
  validates :user_id, presence: true
  validates :folder_id, presence: true
end
