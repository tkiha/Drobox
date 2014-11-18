class RenameFileIdToFileShare < ActiveRecord::Migration
  def change
    rename_column :file_shares, :file_id, :upfile_id
  end
end
