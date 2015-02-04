class Upfile < ActiveRecord::Base
  belongs_to :folder
  belongs_to :own_user, class_name: :User, foreign_key: :user_id
  has_many :file_shares, inverse_of: :upfile, dependent: :destroy
  accepts_nested_attributes_for :file_shares, allow_destroy: true
  has_many :from_share_users, through: :file_shares, source: :from_user
  has_many :to_share_users, through: :file_shares, source: :to_user

  validate :my_folder
  validates :name, presence: true,
    length: {maximum: 100}
  validates :user_id, presence: true
  validates :folder_id, presence: true

  after_create  -> {
    add_event(Const.event_type.create, self.user_id)
  }
  after_update  -> {
    add_event(Const.event_type.update, self.user_id)
  }
  after_destroy -> {
    add_event(Const.event_type.destroy, self.user_id)
  }

  def move(moveto_folder_id)
    if self.folder_id.to_s == moveto_folder_id
      errors.add(:folder_id, "同じフォルダへは移動できません。")
      return false
    end
    self.transaction do
      self.folder_id = moveto_folder_id
      self.save!
      add_event(Const.event_type.move, self.user_id)
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
      add_event(Const.event_type.copy, self.user_id)
    end
    true
  rescue => e
    errors.add(:folder_id, "コピーできませんでした。#{e.message}")
    false
  end

  def deliver_shared_email
    self.file_shares.each do |item|
      NoticeMailer.sendmail_share(self, item.to_user).deliver
    end
  end

  def add_event(event_type, user_id)
    Event.create(upfile_id: self.id,
                 upfile_name: self.name,
                 event_type: event_type,
                 user_id: user_id
                 )
  end

  attr_accessor :current_user

  private
    def my_folder
      errors.add(:folder_id, '不正なフォルダです') unless User.find(self.user_id).folders.pluck(:id).include?(self.folder_id)
    end
end
