class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :confirmable
  has_many :upfiles
  has_many :file_shares
  # ユーザーが共有しているファイル
  has_many :share_files, through: :file_shares, source: :upfile

  has_many :folders
  has_many :folder_shares
  # ユーザーが共有しているフォルダ
  has_many :share_folders, through: :folder_shares, source: :folder
end
