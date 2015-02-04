class FolderShare < ActiveRecord::Base
  belongs_to :from_user, class_name: :User, foreign_key: :from_user_id
  belongs_to :to_user, class_name: :User, foreign_key: :to_user_id
  belongs_to :folder, inverse_of: :folder_shares

  validates :from_user_id, presence: true
  validates :to_user_id, presence: true
  validates :folder_id, presence: true
  validates :folder_id,
    uniqueness: {
      message: "同じ共有相手は指定できません。",
      scope: [:from_user_id, :to_user_id]
    }

  before_validation :set_from_user_id
  def set_from_user_id
    self.from_user_id = self.folder.current_user.id
  end
end
