class Folder < ActiveRecord::Base
  has_many :upfiles, dependent: :destroy
  belongs_to :own_user, class_name: :User, foreign_key: :user_id
  has_many :folder_shares, :dependent => :destroy
  accepts_nested_attributes_for :folder_shares, allow_destroy: true
  has_many :from_share_users, through: :folder_shares, source: :from_user
  has_many :to_share_users, through: :folder_shares, source: :to_user

  has_many :sub_folders, class_name: :Folder, foreign_key: :parent_folder_id , dependent: :destroy
  belongs_to :parent_folder, class_name: :Folder, foreign_key: :parent_folder_id

  scope :root_folder, -> { find_by(parent_folder_id: nil) }
  scope :get_folder_or_root, ->(folder_id){
    folder_id.blank? ? root_folder : find_by(id: folder_id) || root_folder
  }

  validate :my_parent_folder
  validates :name, presence: true,
    length: {maximum: 100}
  validates :user_id, presence: true

  after_create  -> {
    Event.create(event: "フォルダ#{self.name}を作成しました",
                 user_id: self.user_id)
  }
  after_update  -> {
    Event.create(event: "フォルダ#{self.name}を更新しました",
                 user_id: self.user_id)
  }
  after_destroy -> {
    Event.create(event: "フォルダ#{self.name}を削除しました",
                 user_id: self.user_id)
  }

  # before_save :tes
  # def tes
  #   p "folder before_save --->#{self}"
  #   p "--->#{self.current_user}"
  # end


  # def disp_update_time
  #   return self.updated_at.in_time_zone('Tokyo')
  # end

  def get_family_folders
    families = {}
    families[:parent] = { id: self.parent_folder.id, name:self.parent_folder.name } unless self.parent_folder_id.blank?
    families[:self]   = { id: self.id, name: self.name }
    if self.sub_folders.present?
      childs = []
      self.sub_folders.each do |sub_folder|
        childs << { id: sub_folder.id, name: sub_folder.name }
      end
      families[:child] = childs
    end
    families
  end

  # 親を辿ってparents配列にセットする
  def all_parents(parents)
    parents << self
    parent = self.parent_folder
    parent.all_parents(parents) if parent.present?
  end

  # フォルダを中身を含めて移動する
  def deepmove(moveto_folder_id)
    if self.id.to_s == moveto_folder_id
      errors.add(:parent_folder_id, "同じフォルダへは移動できません。")
      return false
    end
    subfolders = self.get_subfolders([])
    self.transaction do
      if subfolders.include?(moveto_folder_id.to_i)
        # 自分のサブフォルダ内に移動する場合は、親子関係が崩れるので
        # 崩れないようにつなぎ直す
        self.sub_folders.each do |sub_folder|
          sub_folder.parent_folder_id = self.parent_folder_id
          sub_folder.save!
        end
      end
      self.parent_folder_id = moveto_folder_id
      self.save!
      Event.create!(event: "フォルダ#{self.name}を移動しました",
                   user_id: self.user_id)
    end
      true
    rescue => e
      errors.add(:parent_folder_id, "移動できませんでした。#{e.message}")
      false
  end

  def get_subfolders(subfolders)
    if self.sub_folders.present?
      self.sub_folders.each do |sub_folder|
        subfolders << sub_folder.id
        sub_folder.get_subfolders(subfolders)
      end
    end
    subfolders
  end

  # フォルダを中身を含めてコピーする
  def deepcopy(copyto_folder_id)
    if self.id.to_s == copyto_folder_id
      errors.add(:parent_folder_id, "同じフォルダへはコピーできません。")
      return false
    end
    self.transaction do
      self.id == copyto_folder_id
      copyfolder = self.dup
      copyfolder.parent_folder_id = copyto_folder_id
      copyfolder.save!
      Event.create!(event: "フォルダ#{self.name}をコピーしました",
                   user_id: self.user_id)
      self.copyall(copyfolder)
    end
      true
    rescue => e
      errors.add(:parent_folder_id, "コピーできませんでした。#{e.message}")
      false
  end

  def cepyall(copyto_folder)
    self.upfiles.each do |upfile|
      copyfile = upfile.dup
      copyfile.folder_id = copyto_folder.id
      copyfile.save!
      Event.create!(event: "ファイル#{upfile.name}をコピーしました",
                   user_id: upfile.user_id)
    end
    self.sub_folders.each do |subfolder|
      copyfolder = subfolder.dup
      copyfolder.parent_folder_id = copyto_folder.id
      copyfolder.save!
      Event.create!(event: "フォルダ#{subfolder.name}をコピーしました",
                   user_id: subfolder.user_id)
      subfolder.copyall(copyfolder)
    end

  end

  def deliver_shared_email
    self.folder_shares.each do |item|
      NoticeMailer.sendmail_share(self, item.to_user).deliver
    end
  end

  # attr_accessor :current_user

  private
    def my_parent_folder
      return if self.parent_folder_id.blank?

      errors.add(:parent_folder_id, '不正な親フォルダです') unless User.find(self.user_id).folders.pluck(:id).include?(self.parent_folder_id)
    end
end
