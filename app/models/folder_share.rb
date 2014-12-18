class FolderShare < ActiveRecord::Base
  belongs_to :from_user, class_name: :User, foreign_key: :from_user_id
  belongs_to :to_user, class_name: :User, foreign_key: :to_user_id
  belongs_to :folder

  validates :from_user_id, presence: true
  validates :to_user_id, presence: true
  validates :folder_id, presence: true
end
