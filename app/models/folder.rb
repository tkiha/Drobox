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

  validates :name, presence: true,
    length: {maximum: 100}
  validates :user_id, presence: true

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
end
