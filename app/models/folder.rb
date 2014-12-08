class Folder < ActiveRecord::Base
  before_destroy :include_check
  has_many :upfiles
  belongs_to :own_user, class_name: :User
  has_many :folder_shares
  has_many :from_share_users, through: :folder_shares, source: :from_user

  has_many :sub_folders, class_name: :Folder, foreign_key: :parent_folder_id
  belongs_to :parent_folder, class_name: :Folder, foreign_key: :parent_folder_id

  scope :root_folder, -> { find_by(parent_folder_id: nil) }
  scope :get_folder_or_root, ->(folder_id){
    folder_id.blank? ? root_folder : find(folder_id)
  }

  validate :my_parent_folder
  validates :name, presence: true,
    length: {maximum: 100}
  validates :user_id, presence: true

  def disp_update_time
    self.updated_at
  end

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

  # folders/index.htmlに表示するデータを抽出し、並び順を適用する
  def list_folder_source(orderby)
    list = []
    # サブフォルダを抽出
    self.sub_folders.each do |f|
      rec = {
        Const.orderby.field.file => f.name,
        Const.orderby.field.type => ApplicationController.helpers.get_disp_type_name(f),
        Const.orderby.field.time => ApplicationController.helpers.get_disp_update_time(f),
        object: f
      }
      list << rec
    end
    
    # フォルダ内のファイルを抽出
    self.upfiles.each do |f|
      rec = {
        Const.orderby.field.file => f.name,
        Const.orderby.field.type => ApplicationController.helpers.get_disp_type_name(f),
        Const.orderby.field.time => ApplicationController.helpers.get_disp_update_time(f),
        object: f
      }
      list << rec
    end
    # 並べ替え
    orderby_item, orderby_value = ApplicationController.helpers.get_orderby_params(orderby)
    # p "#{orderby_value} #{Const.orderby.none.to_s}"
    if orderby_value != Const.orderby.none
      list.sort_by! {|item| item[orderby_item]}
      list.reverse! if orderby_value == Const.orderby.desc
      # p '+++'
    end
    list
  end

  # フォルダをまるっとコピーする
  def deepcopy(copyto_folder_id)
    self.transaction do
      copyfolder = self.dup
      copyfolder.parent_folder_id = copyto_folder_id
      copyfolder.save!
      self.copyall(copyfolder)
    end
      true
    rescue => e
      errors.add(:parent_folder_id, "コピーできませんでした。#{e.message}")
      false
  end

  def copyall(copyto_folder)
    self.upfiles.each do |upfile|
      copyfile = upfile.dup
      copyfile.folder_id = copyto_folder.id
      copyfile.save!
    end
    self.sub_folders.each do |subfolder|
      copyfolder = subfolder.dup
      copyfolder.parent_folder_id = copyto_folder.id
      copyfolder.save!
      subfolder.copyall(copyfolder)
    end

  end


  private
    def include_check
      if self.sub_folders.present?
        errors[:custom_check] << "サブフォルダがあるので削除できません"
        return false
      end
      if self.upfiles.present?
        errors[:custom_check] << "フォルダの中にファイルがあるので削除できません"
        return false
      end
    end

    def my_parent_folder
      return if self.parent_folder_id.blank?

      errors.add(:parent_folder_id, '不正な親フォルダです') unless User.find(self.user_id).folders.pluck(:id).include?(self.parent_folder_id)
    end

end
