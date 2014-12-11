class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable
  after_save :generate_root_folder
  
  has_many :upfiles
  has_many :from_shares, class_name: :FileShare, foreign_key: :from_user_id
  # ユーザーが共有しているファイル
  has_many :from_share_files, through: :from_shares, source: :upfile

  has_many :folders
  has_many :folder_shares, class_name: :FolderShare, foreign_key: :from_user_id
  # ユーザーが共有しているフォルダ
  has_many :from_share_folders, through: :folder_shares, source: :folder

  private
  def generate_root_folder
    self.folders.build(name: 'root').save unless self.folders.root_folder.present?
  end
end
