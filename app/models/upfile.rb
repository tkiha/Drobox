class Upfile < ActiveRecord::Base
  belongs_to :folder
  belongs_to :own_user, class_name: :User
  has_many :file_shares
  has_many :from_share_users, through: :file_shares, source: :from_user

  validate :my_folder
  validates :name, presence: true,
    length: {maximum: 100}
  validates :user_id, presence: true
  validates :folder_id, presence: true


  private

    def my_folder
      p "==>#{self.folder_id.inspect}"
      p "==>#{User.find(self.user_id).folders.pluck.inspect}"
      errors.add(:folder_id, '不正なフォルダです') unless User.find(self.user_id).folders.pluck(:id).include?(self.folder_id)
    end
end
