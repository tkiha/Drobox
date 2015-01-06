class Upfile < ActiveRecord::Base
  belongs_to :folder
  belongs_to :own_user, class_name: :User, foreign_key: :user_id
  has_many :file_shares, dependent: :destroy
  accepts_nested_attributes_for :file_shares, allow_destroy: true
  has_many :from_share_users, through: :file_shares, source: :from_user
  has_many :to_share_users, through: :file_shares, source: :to_user

  validate :my_folder
  validates :name, presence: true,
    length: {maximum: 100}
  validates :user_id, presence: true
  validates :folder_id, presence: true

  after_create  -> {
    Event.create(event: "ファイル#{self.name}を追加しました",
                 user_id: self.user_id)
  }
  after_update  -> {
    Event.create(event: "ファイル#{self.name}を更新しました",
                 user_id: self.user_id)
  }
  after_destroy -> {
    Event.create(event: "ファイル#{self.name}を削除しました",
                 user_id: self.user_id)
  }

  def move(moveto_folder_id)
    if self.folder_id.to_s == moveto_folder_id
      errors.add(:folder_id, "同じフォルダへは移動できません。")
      return false
    end
    self.transaction do
      self.folder_id = moveto_folder_id
      self.save!
      Event.create!(event: "ファイル#{self.name}を移動しました",
                   user_id: self.user_id)
    end
      true
    rescue => e
      errors.add(:folder_id, "移動できませんでした。#{e.message}")
      false
  end

  def copy(copyto_folder_id)
    self.transaction do
      copyfile = self.dup
      copyfile.folder_id = copyto_folder_id
      copyfile.save!
      Event.create!(event: "ファイル#{self.name}をコピーしました",
                   user_id: self.user_id)
    end
      true
    rescue => e
      errors.add(:folder_id, "コピーできませんでした。#{e.message}")
      false
  end

  private
    def my_folder
      errors.add(:folder_id, '不正なフォルダです') unless User.find(self.user_id).folders.pluck(:id).include?(self.folder_id)
    end
end
